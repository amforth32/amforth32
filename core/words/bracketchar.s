# SPDX-License-Identifier: GPL-3.0-only

IMMED "[char]", BRACKETCHAR /* ( -- )(C: "ccc" -- ) compile first letter of "ccc" as literal */
    .word XT_COMPILE
    .word XT_DOLITERAL
    .word XT_CHAR
.if WANT_TRANSPILER == YES
    .word XT_TPILE_LIT
.endif
    .word XT_COMMA
    .word XT_EXIT
END BRACKETCHAR
