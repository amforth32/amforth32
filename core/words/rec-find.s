# SPDX-License-Identifier: GPL-3.0-only

COLON "rec-find", REC_FIND
    .word XT_FINDXT
    .word XT_DUP
    .word XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
        .word XT_DROP
        .word XT_RECTYPE_NULL
        .word XT_EXIT
1:
    .word XT_RECTYPE_XT
    .word XT_EXIT
END REC_FIND

DATA "rectype-xt", RECTYPE_XT
    .word XT_R_WORD_INTERPRET
    .word XT_R_WORD_COMPILE
    .word XT_2LITERAL
END RECTYPE_XT

NONAME "rword.interpret", R_WORD_INTERPRET
    .word XT_DROP 
    .word XT_EXECUTE
    .word XT_EXIT
END R_WORD_INTERPRET

NONAME "rword.compile", R_WORD_COMPILE
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH,1f
.if WANT_TRANSPILER == YES
        .word XT_TPILE_XT
.endif
	    .word XT_COMMA
        .word XT_EXIT
1:
    .word XT_EXECUTE
    .word XT_EXIT
END R_WORD_COMPILE
