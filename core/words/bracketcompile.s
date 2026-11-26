# SPDX-License-Identifier: GPL-3.0-only

IMMED "[compile]", BRACKETCOMPILE /* ( -- )(C: "name" -- ) compile code that will append XT of "name" to the dictionary */
    .word XT_COMPILE
    .word XT_COMPILE
    .word XT_TICK
.if WANT_TRANSPILER == YES
    .word XT_DUP
    .word XT_COMMA
    .word XT_TPILE_XT
.else
    .word XT_COMMA
.endif

    .word XT_EXIT
END BRACKETCOMPILE
