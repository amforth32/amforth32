# SPDX-License-Identifier: GPL-3.0-only
COLON "defer!", DEFER_STORE /* ( xt1 xt2 -- ) stores xt1 as the xt to be executed when xt2 is called */
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_EXIT
END DEFER_STORE

# COLON "defer!", DEFERSTORE
#     .word XT_TO_BODY
#     .word XT_DUP, XT_FETCH,XT_SWAP
#     .word XT_CELLPLUS
#     .word XT_CELLPLUS
#     .word XT_CELLPLUS
#     .word XT_FETCH
#     .word XT_EXECUTE
#     .word XT_EXIT

