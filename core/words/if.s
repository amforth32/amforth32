# SPDX-License-Identifier: GPL-3.0-only

IMMED "if", IF /* ( f -- )(C: -- a ) if f is false jump past else or then */
    .word XT_QNOP
    .word XT_COMPILE
    .word XT_DOCONDBRANCH
    .word XT_GMARK
    .word XT_EXIT
END IF
