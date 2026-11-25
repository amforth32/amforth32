/*
CONSTANT "taskn" , TASKN , TASKN
END TASKN

CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
END TASK_BLOCK
*/

HEADLESS "task.save", TASK_SAVE /* ( -- ) save current task state into UA */
    str DSP, [UP, #USER_SP]
    str sp,  [UP, #USER_RP]
    str FIP, [UP, #USER_IP]
    str TOS, [UP, #USER_TOS]
    NEXT
END TASK_SAVE

HEADLESS "task.save.trace", TASK_SAVE_TRACE /* ( -- ) save current task return stack */
/*
    The stack is copied into shared trace_stack, so backtrace should be generated promptly
*/
    ldr r0, [UP, #USER_RP]           @ r0 = current RP (top of return stack)
    add r1, UP, #USER_RP0            @ r1 = base of return stack
    ldr r2, =RAM_upper_trace_stack   @ r2 = destination trace stack

1:  ldr r4, [r1], #-4                @ load from top, decrement r1
    str r4, [r2], #-4                @ store to trace stack, decrement r2
    cmp r0, r1
    bls 1b                           @ loop while r0 <= r1

    NEXT
END TASK_SAVE_TRACE
    

HEADLESS "mtpause", MTPAUSE

.if CORTEXM == YES
    mrs     r0, ipsr
    cbnz    r0, MTPAUSE_done           @ in exception context, no yield
.endif

.if CORTEXM == YES
    mrs r1 , primask
    cpsid i
.endif

    @ Save outgoing state
    str DSP, [UP, #USER_SP]
    str sp,  [UP, #USER_RP]
    str FIP, [UP, #USER_IP]
    str TOS, [UP, #USER_TOS]
    
    @ Find next awake task
MTPAUSE_loop:
    ldr UP, [UP, #USER_LINK]
    ldr r0, [UP, #USER_STATUS]
    cmp r0, #0
    bne MTPAUSE_loop
    
    @ Load incoming state
    ldr DSP, [UP, #USER_SP]
    ldr sp,  [UP, #USER_RP]
    ldr FIP, [UP, #USER_IP]
    ldr TOS, [UP, #USER_TOS]

.if CORTEXM == YES
    msr primask , r1 
.endif

MTPAUSE_done:
    NEXT
END MTPAUSE

