# SPDX-License-Identifier: GPL-3.0-only

COLON "constant", CONSTANT /* ( -- x )(C: x "name" -- ) create constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WORD
.endif
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
.if WANT_TRANSPILER == YES
    .word XT_TPILE_LIT
.endif
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
.if WANT_TRANSPILER == YES
    .word XT_TPILE_END
.endif
    .word XT_EXIT
END CONSTANT
