# SPDX-License-Identifier: GPL-3.0-only

COLON "value", VALUE /* ( x "name" -- ) create value "name" with initial of x */
    .word XT_FLAGDOTVALUE
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WORD
.endif
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
.if WANT_TRANSPILER == YES
    .word XT_TPILE_LIT
.endif
    .word XT_RAMCOMMA
    # added 
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    # end added
.if WANT_TRANSPILER == YES
    .word XT_TPILE_END
.endif
    .word XT_EXIT
END VALUE

