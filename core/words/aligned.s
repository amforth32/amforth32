# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling k.f on 2024/11/28 17:10:28
# : aligned ( a -- a )
#     (aligned) dup $ff and 0= if
#         >flushlast
#     then
# ;

# ----------------------------------------------------------------------
COLON "aligned", ALIGNED 
	.word XT_LPARENALIGINEDRPAREN
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,ALIGNED_0001 /* if */
#	.word XT_TOFLUSHLAST
ALIGNED_0001: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
