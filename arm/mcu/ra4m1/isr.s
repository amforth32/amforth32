# fall back to nullhandler
.include "arm/isr.s" 

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

    b       DO_EXECUTE             @ enter word via existing inner interpreter

stub_exit:
    pop     {r4-r11, pc}


