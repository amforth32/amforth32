.equ SYST_CSR,   0xE000E010
.equ SYST_RVR,   0xE000E014
.equ SYST_CVR,   0xE000E018
.equ SYST_CALIB, 0xE000E01C

@ -------------------------------------------------------
@ SYSTICK-INIT  ( -- )
@ SysTick max count, processor clock, interrupt enabled
@ -------------------------------------------------------

CODEWORD "systick.init", SYSTICK_INIT /* ( -- ) init (but do not start) systick */
    ldr     r0, =SYST_RVR
    ldr     r1, =0x00FFFFFF        @ max count
    str     r1, [r0]

    ldr     r0, =SYST_CSR
    mov     r1, #0x07              @ CLKSOURCE|TICKINT|ENABLE
    str     r1, [r0]
    NEXT
END SYSTICK_INIT

CODEWORD "systick-", SYSTICKMINUS /* ( -- ) clear systick interrupt flag */
    ldr     r0, =SYST_CSR
    ldr     r0, [r0]               @ read CSR — clears COUNTFLAG
NEXT
END SYSTICKMINUS

CODEWORD "systick@", SYSTICKFETCH /* ( -- n ) read systick counter value */
    savetos
    ldr     r0, =SYST_CVR
    ldr     TOS, [r0]              @ read current counter value
NEXT
END SYSTICKFETCH

CODEWORD "syscsr@", SYSCSRFETCH
    savetos
    ldr     r0, =SYST_CSR
    ldr     TOS, [r0]
NEXT
END SYSCSRFETCH

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

CODEWORD "+int" , PLUSINT
    cpsie   i                      @ clear PRIMASK, enable all maskable interrupts
    NEXT
END PLUSINT    

CODEWORD "-int" , MINUSINT
    cpsid   i                      @ set PRIMASK, disable all maskable interrupts
    NEXT
END MINUSINT

CONSTANT "systick#" SYSTICKHASH , 15
END SYSTICKHASH

