# SPDX-License-Identifier: GPL-3.0-only

COLON "chkdalign", CHKDALIGN /* ( -- ) check DP for cell alignment, throw if not */
	.word XT_DP
	.word XT_DUP
	.word XT_ALIGNED
	.word XT_MINUS
	.word XT_DOCONDBRANCH,CHKDALIGN_0001 /* if */
	.word XT_DOLITERAL, EADRINV, XT_THROW
CHKDALIGN_0001: /* then */
	.word XT_EXIT
END CHKDALIGN
