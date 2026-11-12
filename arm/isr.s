.thumb_func
nullhandler:
/*
   push {r1}
   ldr r1, =#48
   SEMIT r1
   mrs r1, ipsr
   add r1, #48 @ +"0"
   SEMIT r1
   pop {r1}
*/
   
.Lspin_null:
   b .Lspin_null

.thumb_func
faulthandler:
/* 
   push {r1}
   ldr r1, =#70 @ F
   SEMIT r1
   mrs r1, ipsr
   adds r1, #48 @ +"0"
   SEMIT r1
   pop {r1}
*/
.Lspin_fault:
   b .Lspin_fault

.if CORTEXM == YES

.ltorg

    .thumb_func
isrstub:
    push    {r4-r11, lr}

    /* save sp on the now inactive task return stack,
      so that we can reliably restore the saved registers in (exiti) */
    mrs r0, PSP
    str sp, [r0, #-4]!
.if WANT_DEBUGGER == YES
    /* make sure debugger is disabled;
      save DEBUG_BREAK on the interrupted task's return stack as well */
    ldr r1, [UP, #USER_DEBUG_BREAK]
    str r1, [r0, #-4]!
    mov r2, #0
    str r2, [UP, #USER_DEBUG_BREAK]
.endif
    msr PSP, r0

    /* get the handler from the forth vector table */
    mrs     r0, ipsr
    ldr     r1, =RAM_lower_ram_vector
    ldr     FW, [r1, r0, lsl #2]    @ FW = XT for this exception
    cmp     FW, #0                  @ null — no handler?
    beq     stub_exit
    b       DO_EXECUTE              @ enter word via inner interpreter

stub_exit:
    pop     {r4-r11, pc}
.endif
