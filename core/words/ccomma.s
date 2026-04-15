# SPDX-License-Identifier: GPL-3.0-only

DEFER "c," , CCOMMA , XT_CARETCCOMMA /* ( c -- ) append c to the dictionary */

COLON "^c,", CARETCCOMMA
	.word XT_DP
	.word XT_CSTORE
	.word XT_ONE
	.word XT_DALLOT
	.word XT_EXIT
END CARETCCOMMA

# COLON "c,", CCOMMA /* ( c -- ) append c to the dictionary */
#     .word XT_MEMMODE
#     .word XT_DOCONDBRANCH,CCOMMA_0001 /* if */
#     .word XT_DOCCOMMA
#     .word XT_DOBRANCH,CCOMMA_0002
# CCOMMA_0001: # else
#     .word XT_DP
#     .word XT_CSTORE
#     .word XT_ONE
#     .word XT_DALLOT
# CCOMMA_0002: # then
#     .word XT_EXIT
# END CCOMMA
