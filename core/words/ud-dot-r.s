# SPDX-License-Identifier: GPL-3.0-only

COLON "ud.r", UDDOTR /* ( ud u -- ) print ud as unsigned number, right aligned at width u */
    .word  XT_TO_R, XT_L_SHARP, XT_SHARP_S
    .word  XT_SHARP_G, XT_R_FROM,  XT_OVER
    .word  XT_MINUS, XT_SPACES, XT_TYPE, XT_EXIT
END UDDOTR
