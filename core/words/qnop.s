# SPDX-License-Identifier: GPL-3.0-only

COLON "qnop", QNOP
.ifdef RA_FLASH
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QNOP_0001 /* if */
    .word XT_FLASH_CELL
	.word XT_DP
    .word XT_NALIGNED
	.word XT_DP
	.word XT_MINUS
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,QNOP_0002 /* if */
    .word XT_COMPILE
    .word XT_NOP
QNOP_0002: /* then */
QNOP_0001: /* then */
.endif 
	.word XT_EXIT
END QNOP
