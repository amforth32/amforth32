.include "core/config.inc"

.if TARGET_VIRT==1
.equ CORTEXM , NO
.endif

.if TARGET_MPS2 == YES
    /* SysTick's default processor-clock source runs at 25 MHz on the mps2-an386 QEMU machine. */
    .equ SYSTICK_TICKS_PER_MS, 25000
.endif

.equ WANT_SEE , YES
.equ WANT_DEBUGGER, YES
.equ WANT_IGNORECASE , YES


