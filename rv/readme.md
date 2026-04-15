# RISC-V

RISC-V implementation of AmForth aims at `rv32im` targets.

# Register Usage

AmForth requires several registers for its operation. These registers are specifically mapped to registers that are `callee-saved` based on the calling convention.

AmForth Register             |  RISC-V Register
---------------------------- | -------------
FW: Word Pointer             | S1
FIP: Instruction Pointer     | S2
TOS: Top of Stack            | S3
DSP: Data Stack Pointer      | S4
RSP: Return Stack Pointer    | S5
UP: User Pointer             | S6
DEBUG: debugger support (*)  | S7

(*) only used if WANT_DEBUGGER == YES

RISC-V (ilp32) calling convention:
* A0-A7 (Argument/Scratch Registers): Caller-saved. Pass arguments to subroutines and return results.
* T0-T6 (Temporary Registers): Caller-saved.
* S1-S11 (Local Variables): Callee-saved.
* FP (S0 - Frame Pointer): Current stack frame (local stack allocated variables)
* ZERO (X0 - Zero): Hardwired to zero
* RA (X1 - Return Address): Return address from a subroutine.
* SP (X2 - Stack Pointer): Points to the current top of the stack.
* GP (X3 - Global Pointer): Global variable access
* TP (X4 - Thread Pointer): Thread-local variable access
* PC (Program Counter): Current instruction