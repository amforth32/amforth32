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

PSR = find_psr_name()

def in_interrupt(frame):
    rsp = frame.read_register(PSR).cast(gdb.lookup_type("unsigned int"))
    return bool(rsp & 0x1ff)

def read_system_word(address):
    """Read a 32-bit little-endian Cortex-M system register."""
    data = gdb.selected_inferior().read_memory(address, 4)
    return int.from_bytes(bytes(data), byteorder="little")

def stacked_pc(frame):
    """Return the PC saved in the exception stack frame."""
    exc_return = int(frame.read_register("lr"))
    stack_register = "psp" if exc_return & 0x4 else "msp"
    stack_pointer = int(frame.read_register(stack_register))
    # An extended FP frame has 18 words ahead of the basic eight-word frame.
    frame_offset = 18 * 4 if not (exc_return & (1 << 4)) else 0
    pc = read_system_word(stack_pointer + frame_offset + 6 * 4)
    return gdb.format_address(pc)

def fault_analysis(frame, exception_number):
    names = {
        3: "HardFault",
        4: "MemManage",
        5: "BusFault",
        6: "UsageFault",
    }
    lines = [f"Fault: {exception_number} ({names.get(exception_number)})"]
    try:
        cfsr = read_system_word(0xE000ED28)
        hfsr = read_system_word(0xE000ED2C)
    except Exception as exc:
        lines.append(f"Fault status: <unavailable: {exc}>")
        return lines

    causes = []
    hfsr_causes = (
        (1, "VECTTBL", "vector table read fault"),
        (30, "FORCED", "escalated configurable fault"),
        (31, "DEBUGEVT", "debug event"),
    )
    causes.extend([name, description] for bit, name, description in hfsr_causes if hfsr & (1 << bit))
    cfsr_causes = (
        (0, "IACCVIOL", "instruction access violation"),
        (1, "DACCVIOL", "data access violation"),
        (3, "MUNSTKERR", "MemManage unstacking error"),
        (4, "MSTKERR", "MemManage stacking error"),
        (5, "MLSPERR", "MemManage lazy FP state preservation error"),
        (8, "IBUSERR", "instruction bus error"),
        (9, "PRECISERR", "precise data bus error"),
        (10, "IMPRECISERR", "imprecise data bus error"),
        (11, "UNSTKERR", "BusFault unstacking error"),
        (12, "STKERR", "BusFault stacking error"),
        (13, "LSPERR", "BusFault lazy FP state preservation error"),
        (16, "UNDEFINSTR", "undefined instruction"),
        (17, "INVSTATE", "invalid state"),
        (18, "INVPC", "invalid PC load"),
        (19, "NOCP", "no coprocessor available"),
        (20, "SKTOF", "stack overflow"),
        (24, "UNALIGNED", "unaligned access"),
        (25, "DIVBYZERO", "divide by zero")
    )
    causes.extend([name, description] for bit, name, description in cfsr_causes if cfsr & (1 << bit))
    if causes:
        lines.extend(f"{name}: {description}" for name, description in causes if causes)
    else:
        lines.append("no status bits set")

    # MMFARVALID and BFARVALID indicate whether these registers hold the
    # address associated with the recorded fault.
    for valid_bit, address_register, label in (
        (7, 0xE000ED34, "MMFAR"),
        (15, 0xE000ED38, "BFAR"),
    ):
        if cfsr & (1 << valid_bit):
            try:
                address = read_system_word(address_register)
                lines.append(f"Address ({label}): {gdb.format_address(address)}")
            except Exception:
                lines.append(f"Address ({label}): <unavailable>")
    # IBUSERR, PRECISERR, etc identify precise faults; the stacked PC points
    # to the instruction that caused the fault, while BFAR/MMFAR identifies
    # the data address for a precise data access fault.
    if cfsr & ((1 << 0) | ( 1 << 1) | (1 << 8) | (1 << 9) | (1 << 10)):
        try:
            lines.append(f"Instruction (PC): {stacked_pc(frame)}")
        except Exception:
            lines.append("Instruction (PC): <unavailable>")
    return lines

def exception_analysis(frame, psr_name):
    try:
        exception_number = int(frame.read_register(psr_name)) & 0x1ff
    except Exception:
        return []
    if exception_number == 0:
        return []

    if exception_number in (3, 4, 5, 6):
        return fault_analysis(frame, exception_number)

    exception_names = {
        1: "Reset",
        2: "NMI",
        3: "HardFault",
        4: "MemManage",
        5: "BusFault",
        6: "UsageFault",
        11: "SVCall",
        12: "DebugMonitor",
        14: "PendSV",
        15: "SysTick",
    }
    name = exception_names.get(exception_number)
    if exception_number >= 16:
        irq_number = exception_number - 16
        name = f"IRQ {irq_number}"
    lines = [f"Exception: {exception_number}" + (f" ({name})" if name else "")]
    return lines

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
        lines.extend(exception_analysis(frame, psr_name))
    else:
        lines.append(register_prefix("PSR") + "<not found>")

    return lines
