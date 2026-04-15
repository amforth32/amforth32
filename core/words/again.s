# SPDX-License-Identifier: GPL-3.0-only

IMMED "again", AGAIN /* ( -- )(C: a -- ) unconditional jump back to begin */
    .word XT_QNOP
    .word XT_COMPILE
    .word XT_DOBRANCH
    .word XT_LRESOLVE
    .word XT_EXIT
END AGAIN
