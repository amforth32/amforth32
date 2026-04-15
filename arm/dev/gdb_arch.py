import gdb
from gdb_shared import *

# Forth register names
DEBUG = "r6"
TOS = "r7"
DSP = "r8"
WD = "r9"
IP = "r10"
UP = "r11"
RSP = "sp"

def status_register(frame, name):
    try:
        reg = frame.read_register(name)
        hex = reg.format_string(format="x")
        msb = reg.bytes[3]
        flags = 'N' if msb & 0x80 else '.'
        flags += 'Z' if msb & 0x40 else '.'
        flags += 'C' if msb & 0x20 else '.'
        flags += 'V' if msb & 0x10 else '.'
        flags += 'Q' if msb & 0x08 else '.'
        return f"{register_prefix(name)}{flags}... {hex}"
    except Exception:
        return f"{register_prefix(name)}<unavailable>"

def find_psr_name():
    architecture = gdb.selected_inferior().architecture()
    registers = [reg.name for reg in architecture.registers()]

    # Prioritize common names
    for name in ["xPSR", "xpsr", "cpsr"]:
        if name in registers:
            return name
    # Generic fallback
    for name in registers:
        if "psr" in name.lower():
            return name
    return None

def register_lines(frame):
    lines = [
        value_register(frame, "r0"),
        value_register(frame, "r1"),
        value_register(frame, "r2"),
        value_register(frame, "r3"),
        value_register(frame, "r4"),
        value_register(frame, "r5"),
        value_register(frame, "r6", "DEBUG"),
        value_register(frame, "r7", "TOS"),
        addres_register(frame, "r8", "DSP"),
        addres_register(frame, "r9", "FW"),
        addres_register(frame, "r10", "FIP"),
        addres_register(frame, "r11", "UP"),
        value_register(frame, "r12"),
        addres_register(frame, "sp", "RSP"),
        addres_register(frame, "lr"),
        addres_register(frame, "pc"),
    ]
    
    psr_name = find_psr_name()
    if psr_name:
        lines.append(status_register(frame, psr_name))
    else:
        lines.append(register_prefix("PSR") + "<not found>")

    return lines