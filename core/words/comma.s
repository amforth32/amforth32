# SPDX-License-Identifier: GPL-3.0-only

DEFER ",", COMMA , XT_CARETCOMMA /* ( x -- ) append x to the dictionary */

COLON "^,", CARETCOMMA /* ( x -- ) append x to RAM dictionary */ 
	.word XT_DP
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT
END CARETCOMMA

# # SPDX-License-Identifier: GPL-3.0-only
# COLON ",", COMMA /* ( x -- ) append x to the dictionary */
#     .word XT_CHKDALIGN
#     .word XT_MEMMODE
#     .word XT_DOCONDBRANCH,COMMA_0001 /* if */
#     .word XT_DOCOMMA
#     .word XT_DOBRANCH,COMMA_0002
# COMMA_0001: # else
#     .word XT_DP
#     .word XT_STORE
#     .word XT_CELL
#     .word XT_DALLOT
# COMMA_0002: # then
#     .word XT_EXIT
# END COMMA
