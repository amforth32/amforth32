/*
CONSTANT "taskn" , TASKN , TASKN
END TASKN

CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
END TASK_BLOCK
*/

CODEWORD "mtpause", MTPAUSE

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
    beq MTPAUSE_loop
    
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

