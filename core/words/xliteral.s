# SPDX-License-Identifier: GPL-3.0-only

IMMED "xliteral", XLITERAL
        .word XT_COMPILE
        .word XT_DOXLITERAL
.if WANT_TRANSPILER == YES
        .word XT_DUP, XT_COMMA, XT_TPILE_XT
.else
        .word XT_COMMA
.endif
        .word XT_EXIT
END XLITERAL
