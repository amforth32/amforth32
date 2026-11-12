# Ref: Cortex-M4 User Guide: 4.4 System timer, SysTick
# Ref: Renesas RA4M1 User Manual: 2.9 SysTick System Timer

# SYST_CSR SysTick Control and Status Register
# Bits   | Name     | Function
# ----------------------------
# [31:17] | -         | Reserved
# [16]    | COUNTFLAG | Returns 1 if timer counted to 0 since last time this was read.
# [15:3]  | -         | Reseverd
# [2]     | CLKSOURCE | Clock source: 0 = external clock / 1 = processor clock.
# [1]     | TICKINT   | Enables SysTick exception request; Software can use COUNTFLAG to determine if SysTick has ever counted to zero.
# [0]     | ENABLE    | Enables the counter
# When ENABLE is set to 1, the counter loads the RELOAD value from the SYST_RVR register
# and then counts down. On reaching 0, it sets the COUNTFLAG to 1 and optionally asserts the
# SysTick depending on the value of TICKINT. It then loads the RELOAD value again, and begins counting.

# SYST_RVR SysTick Reload Value Register (lower 24 bits only)
# The RELOAD value can be any value in the range 0x00000001-0x00FFFFFF. A start value of 0 is possible,
# but has no effect because the SysTick exception request and COUNTFLAG are activated when counting from 1 to 0.
# The RELOAD value is calculated according to its use. For example, to generate a multi-shot
# timer with a period of N processor clock cycles, use a RELOAD value of N-1. If the SysTick
# interrupt is required every 100 clock pulses, set RELOAD to 99.

# SYST_CVR SysTick Current Value Register (lower 24 bits only)
# Reads return the current value of the SysTick counter.
# A write of any value clears the field to 0, and also clears the SYST_CSR COUNTFLAG bit to 0.

.equ SYST_CSR,   0xE000E010
.equ SYST_RVR,   0xE000E014
.equ SYST_CVR,   0xE000E018
.equ SYST_CALIB, 0xE000E01C

CODEWORD "systick.init", SYSTICK_INIT /* ( -- ) initialize systick */
/* set reload value to maximum possible, use processor clock as source
and enable systick interrupt */
    ldr     r0, =SYST_RVR
    ldr     r1, =0x00FFFFFF        @ max count
    str     r1, [r0]

    ldr     r0, =SYST_CSR
    mov     r1, #0x07              @ CLKSOURCE|TICKINT|ENABLE
    str     r1, [r0]
    NEXT
END SYSTICK_INIT

CODEWORD "systick.max", SYSTICK_MAX /* ( -- ) set reload value to maximum possible $00ffffff */
    ldr     r0, =SYST_RVR
    ldr     r1, =0x00FFFFFF        @ max count
    str     r1, [r0]
    NEXT
END SYSTICK_MAX

CODEWORD "systick!" , SYSTICK_STORE /* ( n -- ) write max count */
/* Note that ms implementation requires max count to be large,
ideally maximum possible (see systick.max) */
    ldr     r0, =SYST_RVR
    str     TOS , [r0]
    ldr     r0, =SYST_CVR
    mov     r1, #0
    str     r1, [r0]               @ clear CVR — forces reload
    loadtos
    NEXT
END SYSTICK_STORE   

CODEWORD "systick-", SYSTICKMINUS /* ( -- ) clear systick interrupt flag */
    ldr     r0, =SYST_CSR
    ldr     r0, [r0]               @ read CSR — clears COUNTFLAG
NEXT
END SYSTICKMINUS

CODEWORD "systick@", SYSTICK_FETCH /* ( -- n ) read systick counter value */
    savetos
    ldr     r0, =SYST_CVR
    ldr     TOS, [r0]              @ read current counter value
NEXT
END SYSTICK_FETCH

CODEWORD "syscsr@", SYSCSR_FETCH
    savetos
    ldr     r0, =SYST_CSR
    ldr     TOS, [r0]
NEXT
END SYSCSR_FETCH

CODEWORD "+systick", PLUSSYSTICK /* ( -- ) start systick */
    ldr     r0, =SYST_CSR
    ldr     r1, [r0]
    orr     r1, r1, #0x01          @ set ENABLE
    str     r1, [r0]
    NEXT
END PLUSSYSTICK

CODEWORD "-systick", MINUSSYSTICK /* ( -- ) stop systick */
    ldr     r0, =SYST_CSR
    ldr     r1, [r0]
    bic     r1, r1, #0x01          @ clear ENABLE
    str     r1, [r0]
    NEXT
END MINUSSYSTICK

CONSTANT "systick.ms", SYSTICK_MS, SYSTICK_TICKS_PER_MS /* ( -- n ) systick ticks per millisecond */
END SYSTICK_MS

CONSTANT "systick#" SYSTICKHASH , 15 /* ( -- n ) ISR slot number */
END SYSTICKHASH

