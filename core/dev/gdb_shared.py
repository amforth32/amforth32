import gdb
import sys
import os

# Append the GDB search directory to Python module search path
# so that the dev/ files can be imported as modules.
# `info directories` returns something like:
# Source directories searched: /Users/martin/forth/amforth/arm/mcu/qemu/../../dev:/Users/martin/forth/amforth/core/dev:$cdir:$cwd
# Append all paths that include amforth to sys.path.
# Note that this file still has to be sourced explicitly.
dirs = gdb.execute("show directories", to_string=True).split(':')[1:]
for dir in dirs:
    if "amforth" in dir: 
        sys.path.append(os.path.normpath(dir.strip()))

def get_sym_val(name, default):
    try:
        return gdb.parse_and_eval(f"&{name}")
    except gdb.error:
        return default

def is_code_address(addr):
    return (CodeFlashEnd == 0 or CodeFlashStart <= addr < CodeFlashEnd) or (CodeRamEnd == 0 or CodeRamStart <= addr < CodeRamEnd)

CodeFlashStart = get_sym_val("flash.low", 0)
CodeFlashEnd = get_sym_val("flash.max", 0)
CodeRamStart = get_sym_val("dp0.ram", 0)
CodeRamEnd = get_sym_val("dp.ram.max", 0)
RAM_lower_datastack = get_sym_val("RAM_lower_datastack", 0x20000000)
RAM_upper_datastack = get_sym_val("RAM_upper_datastack", 0x20000080)
RAM_lower_returnstack = get_sym_val("RAM_lower_returnstack", 0x20000080)
RAM_upper_returnstack = get_sym_val("RAM_upper_returnstack", 0x20000100)
RAM_lower_userarea = get_sym_val("RAM_lower_userarea", 0x20000100)
RAM_upper_userarea = get_sym_val("RAM_upper_userarea", 0x20000188)

def value(val):
    # If val is in the flash code range, treat it as address
    if is_code_address(val):
        return address(val)
    dec = val.format_string(format="d")
    hex = val.format_string(format="x")
    if 0 <= val and val <= 0xFFFF:
        # include binary format if val is sufficiently small
        bin = val.format_string(format="t")
        if val <= 0x100:
            char = val.format_string(format="c")
            return f"{char} {hex} {bin}"
        else:
            return f"{dec} {hex} {bin}"
    else: 
        return f"{dec} {hex}"

def address(val):
    return val.format_string(format="a")

def register_prefix(name, fName = None):
    if fName:
        if len(name+fName) > 5:
            return f"{name}/{fName}:\t"
        else:
            return f"{name}/{fName}:\t\t"
    else:
        return f"{name}:\t\t"

def value_register(frame, name, fName = None):
    try:
        reg = frame.read_register(name)
        return f"{register_prefix(name, fName)}{value(reg)}"
    except Exception:
        return f"{register_prefix(name, fName)}<unavailable>"

def addres_register(frame, name, fName = None):
    try:
        reg = frame.read_register(name)
        addr = reg.format_string(format="a")
        return f"{register_prefix(name, fName)}{addr}"
    except Exception:
        return f"{register_prefix(name, fName)}<unavailable>"
