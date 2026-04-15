# Enhanced GDB windows for enhanced GDB forth layout.
# Loaded by tui-full.gdb
 
import gdb
from gdb_shared import *
from gdb_arch import *

# GdbCommandWindow can be used to define a TUI window
# that invokes a GDB command to produce its contents.
# See ForthParameterStack and ForthReturnStack for examples.
class GdbCommandWindow: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window 
        tui_window.title = self.title
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        try:
            return gdb.execute(self.gdb_command, to_string=True)
        except Exception as exc: 
            return str(exc)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return 
        self._tui_window.write(self.get_contents(), True)

# class ForthParameterStack(GdbCommandWindow):
#     title = "Data Stack"
#     gdb_command = ".s"

# class ForthReturnStack(GdbCommandWindow):
#     title = "Return Stack"
#     gdb_command = ".r"




# ForthRegisterWindow is a custom register view
# showing registers based on what they are used for in AmForth.
class ForthRegisterWindow: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window 
        tui_window.title = "Forth Registers"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"

        return "\n".join(register_lines(frame))

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)

# ForthParameterStack shows the contents of the DSP
class ForthDataStack: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window
        tui_window.title = "Forth Data Stack"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        # TODO: need to detect when stack is empty
        lines = [ value_register(frame, TOS, "TOS") ]
        dsp = frame.read_register(DSP).cast(gdb.lookup_type("unsigned int").pointer())

        if not (RAM_lower_datastack <= dsp <= RAM_upper_datastack):
            return (f"DSP 0x{dsp} out of range.\n"
                    f"Expected [0x{RAM_lower_datastack}, 0x{RAM_upper_datastack})")

        if dsp == RAM_upper_datastack:
            return f"Empty"
    
        # cast dsp from int to int* so that we can dereference it
        dsp = dsp.cast(dsp.type.pointer())
        count = 0
        while dsp < RAM_upper_datastack and count < 16:
            addr = dsp.format_string(format="x")
            lines.append(f"{addr}:\t{value(dsp.dereference())}")
            dsp += 1
            count += 1
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)

# ForthReturnStack shows the contents of the RSP
class ForthReturnStack: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window
        tui_window.title = "Forth Return Stack"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        w = frame.read_register(WD) # FW
        lines = [
            addres_register(frame, WD, "FW"),
            addres_register(frame, IP, "FIP")
        ]
        rsp = frame.read_register(RSP).cast(gdb.lookup_type("unsigned int").pointer())

        if not (RAM_lower_returnstack <= rsp <= RAM_upper_returnstack):
            return (f"SP 0x{rsp} out of range.\n"
                    f"Expected [0x{RAM_lower_returnstack}, 0x{RAM_upper_returnstack})")

        # cast rsp from int to int* so that we can dereference it
        rsp = rsp.cast(rsp.type.pointer())
        count = 0
        while rsp < RAM_upper_returnstack and count < 16:
            addr = rsp.format_string(format="x")
            lines.append(f"{addr}:\t{gdb.format_address(int(rsp.dereference()))}")
            rsp += 1
            count += 1
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)


gdb.register_window_type("fps", ForthDataStack)
gdb.register_window_type("frs", ForthReturnStack)
gdb.register_window_type("fregs", ForthRegisterWindow)



# GDB Python API Notes
#
# To read memory: gdb.selected_inferior().read_memory(addr, length)
# returns memoryview which is a sort of bytearray see dir(memoryview)
# use gdb.format_address(address) to print address with symbol
#
#
# To read register: gdb.selected_frame().read_register("r6")
# returns gdb.Value
# to print value in hex use .format_string(format="x")
#
# gdb.lookup_type("unsigned int")
# gdb.selected_inferior().architecture()

# References
# https://undo.io/resources/enhance-gdb-with-tui/
