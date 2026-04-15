# SPDX-License-Identifier: GPL-3.0-only

COLON "d.r", DDOTR /* ( d u -- ) print d as signed number, right aligned at width u */
    .word XT_TO_R, XT_TUCK, XT_DABS, XT_L_SHARP
    .word XT_SHARP_S, XT_ROT, XT_SIGN, XT_SHARP_G
    .word XT_R_FROM, XT_OVER, XT_MINUS, XT_SPACES
    .word XT_TYPE, XT_EXIT
END DDOTR
