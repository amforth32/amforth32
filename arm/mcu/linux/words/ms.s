RAMALLOT "ms_timespec", 8

CODEWORD "1ms", N1MS /* ( -- ) sleep about 1 ms */
    push {r7}
    ldr  r0, =RAM_lower_ms_timespec
    movs r1, #0
    str  r1, [r0]                  @ tv_sec = 0
    ldr  r1, =1000000
    str  r1, [r0, #4]              @ tv_nsec = 1,000,000

    movs r1, #0                    @ rem = NULL
    movs r7, #162                @ nanosleep syscall
    swi #0
    pop {r7}
    NEXT
END N1MS

COLON "ms", MS /* ( n -- ) delay n milliseconds, allowing task switches */
    .word XT_ZERO
    .word XT_QDOCHECK, XT_DOCONDBRANCH, MS_DONE
    .word XT_DODO
MS_LOOP:
    .word XT_N1MS
    .word XT_PAUSE
    .word XT_DOLOOP, MS_LOOP
MS_DONE:
    .word XT_EXIT
END MS
