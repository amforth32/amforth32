# SPDX-License-Identifier: GPL-3.0-only

COLON "<#", L_SHARP /* ( -- ) PNO: initialize HLD to PAD */
    .word XT_PAD, XT_HLD, XT_STORE
    .word XT_EXIT
END L_SHARP

COLON "#", SHARP /* ( d1 -- d2 ) PNO: convert one digit */
    .word XT_BASE, XT_FETCH
    .word XT_ZERO
    .word XT_UDSLASHMOD
    .word XT_ROT
    .word XT_DROP
    .word XT_ROT
    .word XT_DOLITERAL, 9
    .word XT_OVER, XT_LESS
    .word XT_DOCONDBRANCH, PFA_SHARP1
    .word XT_DOLITERAL, 7, XT_PLUS
PFA_SHARP1:
    .word XT_DOLITERAL, 48, XT_PLUS
    .word XT_HOLD, XT_EXIT
END SHARP

COLON "#s", SHARP_S /* ( d -- 0 ) PNO: convert all digits until 0 (zero) is reached */
    .word XT_SHARP, XT_2DUP, XT_OR
    .word XT_ZEROEQUAL, XT_DOCONDBRANCH, PFA_SHARP_S
    .word XT_EXIT
END SHARP_S

COLON "#>", SHARP_G /* ( d -- s ) PNO: convert PNO buffer into a string */
    .word XT_2DROP, XT_HLD, XT_FETCH
    .word XT_PAD, XT_OVER, XT_MINUS
    .word XT_EXIT
END SHARP_G
