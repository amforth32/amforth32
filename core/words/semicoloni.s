# SPDX-License-Identifier: GPL-3.0-only

IMMED "\x3bi", SEMICOLONI /* ( -- ) finish interrupt colon word definition */ 
    .word XT_COMPILE
    .word XT_EXITI
.if WANT_TRANSPILER == YES
    .word XT_TPILE_END
.endif
    .word XT_LBRACKET
    .word XT_REVEAL
# addition for EOW marker     
    # .word XT_DOLITERAL
    # .word 0xE339E339
    # .word XT_COMMA
# end addition
    .word XT_FLASHDOTFLUSH
    .word XT_EXIT
END SEMICOLONI
