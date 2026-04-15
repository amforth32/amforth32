# SPDX-License-Identifier: GPL-3.0-only

IMMED "xliteral", XLITERAL
        .word XT_COMPILE
        .word XT_DOXLITERAL
.if WANT_TRANSPILER == YES
        .word XT_TPILE_LIT
.endif
        .word XT_COMMA
        .word XT_EXIT
END XLITERAL
