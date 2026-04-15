#======================================================================
#======================================================================
# transpiling dalign.f on 2026/03/16 19:30:45
# \ SPDX-License-Identifier: GPL-3.0-only
# 
# : dalign \# ( -- )  CELL align dp
#     \ moving one byte at a time to cell alignment
#     \ allows (dallot) in dallot to flush the cache if it
#     \ needs to
#     \
#     \ flash.cell 2
#     \ create ant 1 c, dalign
#     \
#     \ flash.cell 8
#     \ create ant 0 , 1 c, 2 c, 3 c, dalign
# 
#     dp aligned dp - 0 ?do 1 dallot loop
# ;

# ----------------------------------------------------------------------
COLON "dalign", DALIGN /* ( -- ) cell align dp */
# comment \ hanging on its own 9
	.word XT_DP
	.word XT_ALIGNED
	.word XT_DP
	.word XT_MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DALIGN_0001 /* ?do */
	.word XT_DODO
DALIGN_0002: /* do */
	.word XT_ONE
	.word XT_DALLOT
	.word XT_DOLOOP,DALIGN_0002 /* loop */
DALIGN_0001: /* (for ?do IF required) */
	.word XT_EXIT
END DALIGN
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
