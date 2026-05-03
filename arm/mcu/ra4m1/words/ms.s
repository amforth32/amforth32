CODEWORD  "1ms", 1MS

    mov  r0, #12000 /* 12000 x 4 cycles = 1ms @ 48MHz */
1:
    subs r0,r0,#1   /* 1 cycle hazard on r0 */
    nop             /* 1 cycle force hazard */
    bne.w  1b       /* 2 cycles             */ 
NEXT
END 1MS

CODEWORD  "2ms", 2MS

    mov  r0, #24000 /* 24000 x 4 cycles = 2ms @ 48MHz */
1:
    subs r0,r0,#1   /* 1 cycle hazard on r0 */
    nop             /* 1 cycle force hazard */
    bne.w  1b       /* 2 cycles             */ 
NEXT
END 2MS

CODEWORD  "3hms", 3HMS

    mov  r0, #18000 /* 18000 x 4 cycles = 1.5ms @ 48MHz */
1:
    subs r0,r0,#1   /* 1 cycle hazard on r0 */
    nop             /* 1 cycle force hazard */
    bne.w  1b       /* 2 cycles             */ 
NEXT
END 3HMS

# COLON "ms", MS 
# 	.word XT_ZERO
# 	.word XT_QDOCHECK, XT_DOCONDBRANCH,MS_0001 /* ?do */
# 	.word XT_DODO
# MS_0002: /* do */
# 	.word XT_1MS
# 	.word XT_PAUSE
# 	.word XT_DOLOOP,MS_0002 /* loop */
# MS_0001: /* (for ?do IF required) */
# 	.word XT_EXIT
# END MS

COLON "ms", MS /* ( n -- ) n ms non-busy delay executing PAUSE */
	.word XT_DOLITERAL
	.word 48000
	.word XT_STAR
	.word XT_TO_R
	.word XT_DWT_FETCH
MS_0001: /* begin */
	.word XT_PAUSE
	.word XT_DWT_FETCH
	.word XT_OVER
	.word XT_MINUS
	.word XT_R_FETCH
	.word XT_UGREATER
	.word XT_DOCONDBRANCH,MS_0001 /* until */
	.word XT_DROP
	.word XT_RDROP
	.word XT_EXIT
END MS
# ----------------------------------------------------------------------




