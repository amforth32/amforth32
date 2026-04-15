# SPDX-License-Identifier: GPL-3.0-only

IMMED "until", UNTIL /* ( f -- )(C: a -- ) if f is true jump back to begin, otherwise leave the loop */
    .word XT_QNOP
    .word XT_COMPILE
    .word XT_DOCONDBRANCH
    .word XT_LRESOLVE
    .word XT_EXIT
END UNTIL
