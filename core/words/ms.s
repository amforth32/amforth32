# No duplicate names found.
#======================================================================
#======================================================================
# transpiling ms.f on 2026/04/29 10:36:29
# : 1ms #10000 0 do 1 drop loop ;
# : ms 0 ?do 1ms pause loop ;

# ----------------------------------------------------------------------
COLON "1ms", N1MS /* 1 ms busy loop */
	.word XT_DOLITERAL
	.word 10000
	.word XT_ZERO
	.word XT_DODO
N1MS_0002: /* do */
	.word XT_ONE
	.word XT_DROP
	.word XT_DOLOOP,N1MS_0002 /* loop */
N1MS_0001: /* (for ?do IF required) */
	.word XT_EXIT
END N1MS
# ----------------------------------------------------------------------
COLON "ms", MS /* ( n -- ) n ms busy loop with PAUSE */
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,MS_0001 /* ?do */
	.word XT_DODO
MS_0002: /* do */
	.word XT_N1MS
	.word XT_PAUSE
	.word XT_DOLOOP,MS_0002 /* loop */
MS_0001: /* (for ?do IF required) */
	.word XT_EXIT
END MS
# ----------------------------------------------------------------------
COLON "tick@" , TICKFETCH /* fetch free running counter value (not implemented) */
    .word XT_DOLITERAL
    .word EUNSUP
    .word XT_THROW
END TICKFETCH
