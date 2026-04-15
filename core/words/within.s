# SPDX-License-Identifier: GPL-3.0-only

COLON "within", WITHIN /* ( n min max -- f ) f = min <= n < max | max < min <= n | n < max < min  */
    .word XT_OVER
    .word XT_MINUS
    .word XT_TO_R
    .word XT_MINUS
    .word XT_R_FROM
    .word XT_ULESS
    .word XT_EXIT
END WITHIN
