# SPDX-License-Identifier: GPL-3.0-only

IMMED "recurse", RECURSE /* (C: -- ) compile the XT of the word currently being defined into the dictionary */
    .word XT_LATEST
    .word XT_FETCH
.if WANT_TRANSPILER == YES
    .word XT_TPILE_XT
.endif
    .word XT_COMMA
    .word XT_EXIT
END RECURSE
