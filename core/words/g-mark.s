# SPDX-License-Identifier: GPL-3.0-only

NONAME ">mark", GMARK /* ( -- addr ) allocate and store address of forward jump */
.ifdef RA_FLASH
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,GMARK_0001 /* if */
	.word XT_DP
	.word XT_DUP
    .word XT_FLASH_CELL
    .word XT_PLUS
    .word XT_DOTO
	.word XT_DP
	.word XT_DOBRANCH,GMARK_0002
GMARK_0001: /* else */
.endif
     .word XT_DP
     .word XT_DUP
     .word XT_CELLPLUS
     .word XT_DOTO
     .word XT_DP
GMARK_0002: /* # then */
.if WANT_TRANSPILER == YES
	.word XT_TPILE_FWD
.endif
	.word XT_EXIT
END GMARK
