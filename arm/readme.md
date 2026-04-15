# ARM-32

ARM implementation of AmForth aims at ARM7 Cortex-M3/M4 targets. It may run on other compatible targets e.g. QEMU -M virt A-15. All code is compiled to Thumb-2 instruction set. Any target that does not start in Thumb mode MUST switch to Thumb mode before entering AmForth code.

# Register Usage

AmForth requires several registers for its operation. These registers are specifically mapped to ARM registers that are `callee-saved` based on ARM calling convention.

AmForth Register             |  ARM Register
---------------------------- | -------------
DEBUG: debugger support (*)  | R6
TOS: Top of Stack            | R7
DSP: Data Stack Pointer      | R8
FW: Word Pointer             | R9
FIP: Instruction Pointer     | R10
UP: User Pointer             | R11
RSP: Return Stack Pointer    | R13 (SP)

(*) only used if WANT_DEBUGGER == YES

Registers R0 to R5 are used as scratch registers.

The ARM calling convention:
* R0-R3 (Argument/Scratch Registers): Pass arguments to subroutines and return results. These are caller-saved (volatile).
* R4-R11 (Local Variables): Callee-saved (non-volatile). A function must preserve these registers.
* R12 (IP - Intra-Procedure-call scratch register): Used e.g by linker veneers for long jumps
* R13 (SP - Stack Pointer): Points to the current top of the stack.
* R14 (LR - Link Register): Stores the return address from a subroutine.
* R15 (PC - Program Counter): Contains the current instruction

Note that some Thumb16 instructions (like cbz, cbnz) support only R0-R7 as arguments, so we need to be judicious in allocating functions/purpose to R4-R7.


# ARM Interworking

PFA symbols for all codewords (i.e. native assembler words) have the thumb bit set (via the .thumb_func directive), to make them safe to call via `bx` (which is what the inner interpreter uses as well).

Labels that are used as jump targets through `b` or `bl` instructions don't need the thumb bit set, if they are known to be "short jumps" (e.g. within the same word file). However, if a label is used as a target for jumps across word files where the distance could change to become long at some point, then it should have the thumb bit set via the `.thumb_func` directive, even if it technically doesn't need it at any given time. This is because the linker can decide to inject a "veneer" in place of such jump instruction that uses `bx` behind the scene. The veneer would looks something like this
```
00008010 <__func_from_arm_veneer>:
    8010: e51ff004    ldr pc, [pc, #-4] ; Load address from literal pool
    8014: 00009000    .word 0x00009000  ; The actual destination
```
This veneer will now cause an interworking failure at runtime if the original label doesn't have the thumb bit set. Setting the bit as a matter of convention future-proofs the code base against surprise breakage from seemingly unrelated change (e.g. just reorganizing files in _dict files or changing the memory locations in the linker script).