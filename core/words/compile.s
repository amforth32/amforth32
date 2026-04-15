# SPDX-License-Identifier: GPL-3.0-only

COLON "compile", COMPILE /* ( -- ) append the XT that follows in the calling word to the dictionary */
/* Assumes it's invoked by an immediate during compilation */
    .word XT_R_FROM
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R
    .word XT_FETCH
.if WANT_TRANSPILER == YES
    .word XT_TPILE_XT
.endif
    .word XT_COMMA
    .word XT_EXIT
END COMPILE

