import asyncio
import sys
import os
import re
import tty
import termios
import serial_asyncio

# Configure your terminal Targets 
DEVICE_PORT = '/dev/tty.usbmodemamforth321'  # Update to match your macOS USB device port path
BAUD_RATE = 115200
HISTORY_FILE = os.path.expanduser('~/.usbshell_history')
HISTORY_MAX = 1000

# Matches: #include filename (strictly no quotes)
INCLUDE_RE = re.compile(r'^\s*#include\s+([^"\s]+)\s*$')

def safe_stdout_write(data: bytes):
    """Bypasses macOS O_NONBLOCK terminal bugs on stdout by tracking exact byte slices."""
    fd = sys.stdout.fileno()
    view = memoryview(data)
    bytes_written = 0
    while bytes_written < len(data):
        try:
            bytes_written += os.write(fd, view[bytes_written:])
        except (BlockingIOError, OSError) as e:
            if e.errno in (35, 11):  # Resource temporarily unavailable (EAGAIN on macOS)
                import time
                time.sleep(0.001)
                continue
            raise e

async def serial_receiver(reader):
    """Continuously prints incoming CDC bytes from the Forth engine to stdout."""
    while True:
        try:
            data = await reader.read(1024)
            if not data:
                break
            safe_stdout_write(data)
        except asyncio.CancelledError:
            break
        except Exception as e:
            print(f"\nRead error: {e}", file=sys.stderr)
            break

async def process_line(line_str: str, writer, visited_files=None):
    """Processes strings and evaluates #include file references recursively."""
    if visited_files is None:
        visited_files = set()

    match = INCLUDE_RE.match(line_str)
    if match:
        include_path = os.path.abspath(match.group(1))
        
        # Prevent infinite compilation lookups if files include each other
        if include_path in visited_files:
            safe_stdout_write(f"\r\n[Error] Circular #include detected: {include_path}\r\n".encode('utf-8'))
            return

        # SAFE DIAGNOSTIC: Bypasses non-blocking stderr hazards completely
        safe_stdout_write(f"\r\n[Info] Including file: {include_path}\r\n".encode('utf-8'))
        safe_stdout_write(f" \r\n>".encode('utf-8'))
        
        if os.path.exists(include_path):
            try:
                # SIMULATED PROMPT: Aligns line 1 perfectly with the others
                safe_stdout_write(b"----> ")

                visited_files.add(include_path)
                with open(include_path, 'r', encoding='utf-8', errors='ignore') as f:
                    for file_line in f:
                        cleaned_file_line = file_line.rstrip('\r\n')
                        # Recursively process lines found inside the target script
                        await process_line(cleaned_file_line, writer, visited_files)
                visited_files.remove(include_path)
            except Exception as e:
                safe_stdout_write(f"[Error] Failed to read {include_path}: {e}\r\n".encode('utf-8'))
        else:
            safe_stdout_write(f"[Warning] File not found: {include_path}\r\n".encode('utf-8'))
        return

    # Forward the raw payload to the Forth engine terminated with a Carriage Return (\r)
    payload = (line_str + "\r").encode('utf-8')
    try:
        writer.write(payload)
        await writer.drain()
    except (BlockingIOError, OSError):
        await asyncio.sleep(0.01)
        writer.write(payload)
        await writer.drain()

def load_history():
    """Load persistent history from disk. Returns a list ordered oldest-first."""
    if not os.path.exists(HISTORY_FILE):
        return []
    try:
        with open(HISTORY_FILE, 'r', encoding='utf-8', errors='ignore') as f:
            lines = [ln.rstrip('\r\n') for ln in f if ln.strip()]
        return lines[-HISTORY_MAX:]
    except Exception:
        return []

def append_history(line_str: str):
    """Append a single line to the history file immediately (survives crashes)."""
    try:
        with open(HISTORY_FILE, 'a', encoding='utf-8', errors='ignore') as f:
            f.write(line_str + '\n')
    except Exception:
        pass  # Never let history I/O kill the shell

async def interactive_no_echo_stdin(writer):
    """Reads keyboard raw sequences on macOS without echoing locally, supporting history and cursor navigation."""
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    
    # Strip local echo and standard canonical processing completely
    tty.setraw(fd)
    
    loop = asyncio.get_running_loop()
    stdin_reader = asyncio.StreamReader()
    protocol = asyncio.StreamReaderProtocol(stdin_reader)
    await loop.connect_read_pipe(lambda: protocol, sys.stdin)

    current_line = []
    cursor_pos = 0  # Track insertion point within current_line
    history = load_history()
    history_index = -1
    saved_input = ""

    #print("\r\nMinicom Mode Active. True Forth Hardware Echo shown. Arrows & Backspace work.\r", file=sys.stderr)

    try:
        await writer.drain()
        writer.write(b'Starting...\r')
        while True:
            char_bytes = await stdin_reader.read(1)
            if not char_bytes:
                break
                
            # --- Intercept ANSI Escape Sequences (Arrows) ---
            if char_bytes == b'\x1b':
                seq = await stdin_reader.read(2)
                
                # Up Arrow: \x1b[A
                if seq == b'[A' and history:
                    if history_index == -1:
                        saved_input = "".join(current_line)
                    if history_index < len(history) - 1:
                        history_index += 1
                        # Backspace over whatever is physically sitting in Forth's ACCEPT buffer right now
                        writer.write(b'\x08' * cursor_pos)
                        await writer.drain()
                        
                        current_line = list(history[-(history_index + 1)])
                        cursor_pos = len(current_line)
                        
                        # Feed the history line straight to Forth's echo buffer
                        writer.write("".join(current_line).encode('utf-8'))
                        await writer.drain()
                        
                # Down Arrow: \x1b[B
                elif seq == b'[B':
                    if history_index >= 0:
                        writer.write(b'\x08' * cursor_pos)
                        await writer.drain()
                        
                        if history_index > 0:
                            history_index -= 1
                            current_line = list(history[-(history_index + 1)])
                        else:
                            history_index = -1
                            current_line = list(saved_input)
                            
                        cursor_pos = len(current_line)
                        writer.write("".join(current_line).encode('utf-8'))
                        await writer.drain()
                        
                # Right Arrow: \x1b[C
                elif seq == b'[C':
                    if cursor_pos < len(current_line):
                        # Advance cursor locally and tell Forth to echo forward
                        char_to_move = current_line[cursor_pos]
                        cursor_pos += 1
                        writer.write(char_to_move.encode('utf-8'))
                        await writer.drain()
                        
                # Left Arrow: \x1b[D
                elif seq == b'[D':
                    if cursor_pos > 0:
                        cursor_pos -= 1
                        # Tell Forth to physically step the cursor backward by sending standard Backspace control
                        writer.write(b'\x08')
                        await writer.drain()
                continue

            char = char_bytes.decode('utf-8', errors='ignore')
            
            # Catch standard exit signals cleanly (Ctrl+C or Ctrl+D)
            if char in ('\x03', '\x04'):
                break
                
            # Catch completion signals (Return key mappings)
            elif char in ('\r', '\n'):
                line_str = "".join(current_line)
                stripped = line_str.strip()
                if stripped in ('#exit', 'bye'):
                    # Rewind Forth's ACCEPT pointer so the word isn't executed; no visual scrub needed
                    writer.write(b'\x08' * cursor_pos)
                    await writer.drain()
                    break
                
                if line_str:
                    # Only record if it differs from the most recent entry
                    if not history or history[-1] != line_str:
                        history.append(line_str)
                        append_history(line_str)
                    
                    if INCLUDE_RE.match(line_str):
                        # Clear line text out of Forth's active ACCEPT window 
                        writer.write(b'\x08' * cursor_pos)
                        await writer.drain()
                        await process_line(line_str, writer)
                    else:
                        # Send only the final carriage return since text is already on Forth side
                        writer.write(b'\r')
                        await writer.drain()
                    
                current_line.clear()
                cursor_pos = 0
                history_index = -1
                saved_input = ""
                
            # --- Handle Backspace (Del key code 127 or Ctrl+H) ---
            elif char in ('\x7f', '\x08'):
                if cursor_pos > 0:
                    cursor_pos -= 1
                    current_line.pop(cursor_pos)
                    
                    # Target a dynamic overwrite: move back, print space to erase, move back again
                    # This ensures it updates cleanly inside both Python and the Forth assembly buffer
                    writer.write(b'\x08 \x08')
                    await writer.drain()
                    
                    # If we deleted from the middle of a string, redraw trailing characters
                    if cursor_pos < len(current_line):
                        remaining = "".join(current_line[cursor_pos:])
                        # Print remaining, clear layout artifacts, and reset cursor position
                        writer.write(f"{remaining} \x08" .encode('utf-8') + b'\x08' * len(remaining))
                        await writer.drain()
                
            # Feed raw text inputs straight across the USB cable
            else:
                # Insert character at the current local cursor position
                current_line.insert(cursor_pos, char)
                cursor_pos += 1
                
                # If typing in the middle of a line, we must echo out the character and everything trailing it
                if cursor_pos < len(current_line):
                    tail = "".join(current_line[cursor_pos-1:])
                    writer.write(tail.encode('utf-8') + b'\x08' * (len(tail) - 1))
                else:
                    writer.write(char_bytes)
                await writer.drain()
                
    finally:
        # Restore user terminal attributes cleanly upon closeout
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        print("\r\nExiting shell controller...", file=sys.stderr)

async def piped_stream_stdin(writer):
    """Sequential reader for script redirects or piped CLI text inputs (< file.in)."""
    loop = asyncio.get_running_loop()
    stdin_reader = asyncio.StreamReader()
    protocol = asyncio.StreamReaderProtocol(stdin_reader)
    await loop.connect_read_pipe(lambda: protocol, sys.stdin)
    
    while True:
        line_bytes = await stdin_reader.readline()
        if not line_bytes:
            break
        line_str = line_bytes.decode('utf-8', errors='ignore').rstrip('\r\n')
        await process_line(line_str, writer)
    
    await writer.drain()
    await asyncio.sleep(0.5)

async def main():
    try:
        reader, writer = await serial_asyncio.open_serial_connection(
            url=DEVICE_PORT, 
            baudrate=BAUD_RATE
        )
    except Exception as e:
        print(f"Error opening {DEVICE_PORT}: {e}", file=sys.stderr)
        return

    # Fire off our listening loop background worker
    receiver_task = asyncio.create_task(serial_receiver(reader))
    
    # Check if we are interactive or piped
    if sys.stdin.isatty():
        await interactive_no_echo_stdin(writer)
    else:
        await piped_stream_stdin(writer)

    receiver_task.cancel()
    writer.close()
    await writer.wait_closed()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
