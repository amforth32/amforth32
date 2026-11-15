.thumb_func
nullhandler:
   push {r1}
   ldr r1, =#48
   SEMIT r1
   mrs r1, ipsr
   add r1, #48 @ +"0"
   SEMIT r1

   pop {r1}
   bx lr

.thumb_func
faulthandler:
   push {r1}

   ldr r1, =#70 @ F
   SEMIT r1
   mrs r1, ipsr
   adds r1, #48 @ +"0"
   SEMIT r1
   pop {r1}
   bx lr

.ltorg

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
    
    ldr     r0 , =RAM_ISR_UP
    str     up , [r0, #USER_LINK]       @ store current task UP in ISR_UP:USER_LINK
    mov     up , r0                     @ load ISR_UP into UP

    @ Load incoming (ISR) state from ISR userarea  
    add     DSP, UP, #USER_SP0           @ fresh data stack (ISRs start clean)
    add     r0,  UP, #USER_RP0           @ fresh return stack    
    mov     sp, r0

    b       DO_EXECUTE             @ enter word via existing inner interpreter

stub_exit:
    pop     {r4-r11, pc}
