# SPDX-License-Identifier: GPL-3.0-only

IMMED "literal", LITERAL /* (C: x -- ) compile code that will append x as a literal to the dictionary */
        .word XT_COMPILE
        .word XT_DOLITERAL
.if WANT_TRANSPILER == YES
        .word XT_TPILE_LIT
.endif
        .word XT_COMMA
        .word XT_EXIT
END LITERAL
