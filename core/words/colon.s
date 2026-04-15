# SPDX-License-Identifier: GPL-3.0-only

COLON ":", COLON /* ( "name" -- ) create a colon word entry in the dictionary */
    .word XT_FLAGDOTCOLON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WORD
.endif
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT
END COLON

