
CODEWORD "cntpct@", CNTPCTFETCH  /* ( -- u ) lower 32 bits of CNTPCT */
    savetos
    mrrc    p15, 0, TOS, r0, c14  @ TOS = low 32, r0 = high (discarded)
    NEXT
END CNTPCTFETCH

CODEWORD "cntfrq@", CNTFRQFETCH  /* ( -- u ) read CNTFRQ */
    savetos
    mrc     p15, 0, TOS, c14, c0, 0
    NEXT
END CNTFRQFETCH

CODEWORD "1ms", N1MS          /* ( -- ) busy-wait 1ms, wrap-safe */
    mrc     p15, 0, r1, c14, c0, 0  @ r1 = CNTFRQ
    mov     r2, #1000
    udiv    r1, r1, r2              @ r1 = ticks per ms
    mrrc    p15, 0, r2, r0, c14    @ r2 = start (low 32)
1:
    mrrc    p15, 0, r3, r0, c14    @ r3 = now (low 32)
    sub     r3, r3, r2             @ r3 = elapsed (wrap-safe)
    cmp     r3, r1
    blo     1b
    NEXT
END N1MS

COLON "ms", MS /* ( n -- ) a non-busy delay of n ms that calls PAUSE */
    .word XT_CNTFRQFETCH
    .word XT_DOLITERAL
    .word 1000
    .word XT_SLASH
    .word XT_STAR
    .word XT_TO_R
    .word XT_CNTPCTFETCH
MS_0001: /* begin */
    .word XT_PAUSE
    .word XT_CNTPCTFETCH
    .word XT_OVER
    .word XT_MINUS
    .word XT_R_FETCH
    .word XT_UGREATER
    .word XT_DOCONDBRANCH,MS_0001 /* until */
    .word XT_DROP
    .word XT_RDROP
    .word XT_EXIT
END MS

CODEALIAS "ms.init", MSDOTINIT, NOP /* ( -- ) start free running counter that back ms */ 
END MSDOTINIT

CODEALIAS "tick@", TICKFETCH, CNTPCTFETCH /* ( -- ) fetch free running counter value */ 
END TICKFETCH

CODEALIAS "ms.tickf" , MSDOTTICKF , CNTFRQFETCH
END MSDOTTICKF

