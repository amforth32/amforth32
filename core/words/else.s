# SPDX-License-Identifier: GPL-3.0-only

IMMED "else", ELSE /* ( -- )(C: a1 -- a2 ) jump past then */
    .word XT_QNOP
    .word XT_COMPILE
    .word XT_DOBRANCH
    .word XT_GMARK
    .word XT_SWAP
    .word XT_GRESOLVE
    .word XT_EXIT
END ELSE
