# fall back to nullhandler
/* .include "arm/isr.s"  */

@ -------------------------------------------------------
@ isrstub
@ -------------------------------------------------------
    .thumb_func
isrstub:
    push    {r4-r11, lr}

    mrs     r0, ipsr
    ldr     r1, =RAM_lower_forthvector
    ldr     FW, [r1, r0, lsl #2]   @ FW = XT for this exception
    cmp     FW, #0                  @ null — no handler?
    beq     stub_exit

    @ --- Task switch: foreground -> ISR ---
    @ Save outgoing (foreground) state into foreground userarea
    str     DSP, [UP, #USER_SP]           @ UP currently = foreground userarea
    str     sp,  [UP, #USER_RP]
    
    ldr     r0 , =ISR_UP
    str     up , [r0, #USER_LINK]

    mov     up , r0 

    @ Load incoming (ISR) state from ISR userarea
    ldr     DSP, [UP, #USER_SP0]           @ fresh data stack (ISRs start clean)
    ldr     sp,  [UP, #USER_RP0]           @ uncomment for Option B (separate RP)    

    b       DO_EXECUTE             @ enter word via existing inner interpreter

stub_exit:
    pop     {r4-r11, pc}


