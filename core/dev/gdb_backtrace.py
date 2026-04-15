import gdb
from gdb_shared import *
from gdb_arch import *
from gdb.unwinder import Unwinder, FrameId

class ForthUnwinder(Unwinder):
    """Unwinder for Forth return stack.
    
    GDB uses the unwinder to interpret the return stack. It seeds the process with a first pending_frame
    that includes the state of all registers, the PC is set to whatever the current PC value is.
    SP points at the top of the return stack.
    The unwinder then builds and return unwind_info for the next pending frame (in the __call__ method).
    The __call__ method is called repeatedly until a None is returned which ends the backtrace building process.
    """
    
    def __init__(self):
        super().__init__("ForthUnwinder")
        self.first_frame_done = False
    
    def __call__(self, pending_frame):
        try:
            uintptr = gdb.lookup_type("unsigned int").pointer()
            rsp = pending_frame.read_register(RSP).cast(uintptr)
            # print(f"FU: #{pending_frame.level()}: rsp={rsp}")

            while True:
                # Stop if we hit stack boundary
                if not (RAM_lower_returnstack <= rsp < RAM_upper_returnstack):
                    # print(f"FU: ! {RAM_lower_returnstack} <= {rsp} < {RAM_upper_returnstack}")
                    self.first_frame_done = False
                    return None

                if self.first_frame_done:
                    ret_addr = rsp.dereference().cast(uintptr)
                else:
                    # Adjust SP for first frame (FIP effectively extends RSP by one slot)
                    rsp -= 1
                    ret_addr = pending_frame.read_register(IP).cast(uintptr)
                    self.first_frame_done = True

                # If ret_addr doesn't look like a valid code address, skip that stack entry
                # because it's likely a value stashed in the return stack.
                if is_code_address(ret_addr):
                    break
                # print(f"skipping non code: #{pending_frame.level()}: {ret_addr}")
                rsp += 1

            # Create frame ID for next frame: use SP (as identity) and ret_addr (as code address)
            frame_id = FrameId(rsp, ret_addr)
            unwind_info = pending_frame.create_unwind_info(frame_id)
            # print(f"FU: rsp={rsp}, pc={ret_addr}")
            unwind_info.add_saved_register("pc", ret_addr)
            unwind_info.add_saved_register(RSP, rsp + 1)            
            return unwind_info

        except Exception as e: 
            import traceback
            traceback.print_exc()
            self.first_frame_done = False
            return None

# Register the unwinder
gdb.unwinder.register_unwinder(None, ForthUnwinder(), replace=False)

# Keeping the code below in case we do need FrameDecorators later.
# This shows how to put it together.

# Frame decorator to enhance Forth frame information
# class ForthFrameDecorator(gdb.FrameDecorator.FrameDecorator):
#     """Decorator to enhance Forth frame display with symbol information."""
    
#     def __init__(self, frame):
#         super().__init__(frame)
    
#     def function(self):
#         """Get function name from symbol."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             # Look up the symbol at this address
#             try:
#                 block = gdb.block_for_pc(pc)
#                 if block and block.function:
#                     return block.function.name
#             except:
#                 pass
#             # Try to get just the symbol name
#             try:
#                 result = gdb.execute(f"info symbol 0x{pc:x}", to_string=True).strip()
#                 if result and "not in any" not in result:
#                     # Extract just the symbol name (before any +offset)
#                     parts = result.split()
#                     if parts:
#                         return parts[0]
#             except:
#                 pass
#         except:
#             pass
#         return None
    
#     def filename(self):
#         """Get source filename if available."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             sal = gdb.find_pc_line(pc)
#             # Only return if we have valid debug info
#             if sal and sal.symtab and sal.line > 0:
#                 return sal.symtab.filename
#         except:
#             pass
#         return None
    
#     def line(self):
#         """Get source line number if available."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             sal = gdb.find_pc_line(pc)
#             # Only return if we have valid debug info
#             if sal and sal.line > 0:
#                 return sal.line
#         except:
#             pass
#         return None

# class ForthFrameFilter:
#     """Filter to apply ForthFrameDecorator to all frames."""
    
#     def __init__(self):
#         self.name = "ForthFrameFilter"
#         self.priority = 100
#         self.enabled = True
#         gdb.frame_filters[self.name] = self
    
#     def filter(self, frame_iter):
#         # Wrap each frame with our decorator
#         for frame in frame_iter:
#             yield ForthFrameDecorator(frame)

# ForthFrameFilter()
