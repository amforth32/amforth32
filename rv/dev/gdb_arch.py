
from gdb_shared import *

# Forth register names

RSP = "s5"
IP = "s2"
WD = "s1"
DSP = "s4"
TOS = "s3"
UP = "s6"
RLIDX = "s7"
RLLIM = "s8"

def register_lines(frame):
    return [
        addres_register(frame, "s1", "FW"),
        addres_register(frame, "s2", "FIP"),
        value_register(frame, "s3", "TOS"),
        addres_register(frame, "s4", "DSP"),
        addres_register(frame, "s5", "RSP"),
        addres_register(frame, "s6", "UP"),
        value_register(frame, "s7", "DEBUG"),
        value_register(frame, "s8"),
        value_register(frame, "s9"),
        value_register(frame, "s10"),
        value_register(frame, "s11"),
        addres_register(frame, "pc"),
        addres_register(frame, "ra"),
        addres_register(frame, "sp"),
        addres_register(frame, "gp"),
        addres_register(frame, "tp"),
        addres_register(frame, "fp"),
        value_register(frame, "t0"),
        value_register(frame, "t1"),
        value_register(frame, "t2"),
        value_register(frame, "t3"),
        value_register(frame, "t4"),
        value_register(frame, "t6"),
        value_register(frame, "a0"),
        value_register(frame, "a1"),
        value_register(frame, "a2"),
        value_register(frame, "a3"),
        value_register(frame, "a4"),
        value_register(frame, "a5"),
        value_register(frame, "a6"),
        value_register(frame, "a7"),
    ]
