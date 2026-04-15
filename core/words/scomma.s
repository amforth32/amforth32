#======================================================================
#======================================================================
# transpiling s.f on 2026/03/03 06:38:06
# : s, ( a u -- )
#     dup c,                                  \ (1)
#     0 ?do dup i + c@ c, loop drop            \ (2)
#     dp dup aligned swap - 0 ?do -1 c, loop  \ (3)
# ;

# ----------------------------------------------------------------------
COLON "s,", SCOMMA /* ( addr u -- ) append string at addr to the dictionary (with count prefix) */
	.word XT_DUP
	.word XT_CCOMMA
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SCOMMA_0001 /* ?do */
	.word XT_DODO
SCOMMA_0002: /* do */
	.word XT_DUP
	.word XT_I
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_CCOMMA
	.word XT_DOLOOP,SCOMMA_0002 /* loop */
SCOMMA_0001: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_DP
	.word XT_DUP
	.word XT_ALIGNED
	.word XT_SWAP
	.word XT_MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SCOMMA_0003 /* ?do */
	.word XT_DODO
SCOMMA_0004: /* do */
    .word XT_DOLITERAL
	.word 0xAA
	.word XT_CCOMMA
	.word XT_DOLOOP,SCOMMA_0004 /* loop */
SCOMMA_0003: /* (for ?do IF required) */
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
