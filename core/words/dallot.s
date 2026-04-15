# SPDX-License-Identifier: GPL-3.0-only

DEFER "dallot" , DALLOT , XT_CARETDALLOT 

COLON "^dallot", CARETDALLOT 
	.word XT_DP
	.word XT_PLUS
    .word XT_DOTO
	.word XT_DP
	.word XT_EXIT
END CARETDALLOT

# COLON "dallot", DALLOT /* ( u -- ) allocate u bytes in the dictionary */
#     .word XT_MEMMODE
#     .word XT_DOCONDBRANCH,DALLOT_0001 /* if */
#     .word XT_DODALLOT
#     .word XT_DOBRANCH,DALLOT_0002
# DALLOT_0001: /* else */
#     .word XT_DP
#     .word XT_PLUS
#     .word XT_DOTO
#     .word XT_DP
# DALLOT_0002: /* then */
#     .word XT_EXIT
# END DALLOT
