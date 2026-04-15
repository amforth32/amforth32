# SPDX-License-Identifier: GPL-3.0-only

IMMED "ahead", AHEAD /* ( -- )(C: -- a ) unconditional jump past then */
    .word XT_QNOP
    .word XT_COMPILE
    .word XT_DOBRANCH
    .word XT_GMARK
    .word XT_EXIT
END AHEAD
