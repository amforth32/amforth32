# SPDX-License-Identifier: GPL-3.0-only
# transpiling dot-k.f on 2024/03/12 07:52:11
# : .k \# ( nN..n1 -- ) OUTPUT: Delete all entries in stack
#     depth 0 ?do drop loop
# ;

# ----------------------------------------------------------------------
COLON ".k", DOTK /* ( nN..n1 -- ) delete all entries in stack */
	.word XT_DEPTH
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTK_0001 /* ?do */
	.word XT_DODO
DOTK_0002: # do
	.word XT_DROP
	.word XT_DOLOOP,DOTK_0002 /* loop */
DOTK_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
