COLON "vdump", VDUMP /* ( addr u -- ) dump u bytes from addr as words */
	.word XT_ZERO
	.word XT_DODO
VDUMP_0002: /* do */
	.word XT_DUP
	.word XT_I
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
	.word XT_FOUR
	.word XT_DOPLUSLOOP,VDUMP_0002 /* # +loop */
VDUMP_0001: /* # (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END VDUMP
