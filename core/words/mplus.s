# SPDX-License-Identifier: GPL-3.0-only

COLON "m+", MPLUS /* ( d1 n -- d2 ) d2 = d1 + n */
    .word XT_S2D
    .word XT_DPLUS
    .word XT_EXIT
END MPLUS
