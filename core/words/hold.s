# SPDX-License-Identifier: GPL-3.0-only

VARIABLE "hld", HLD /* PNO: holds current write position in PNO buffer */
END HLD

COLON "hold", HOLD /* ( c -- ) PNO: prepend character to HLD, move HLD */
    .word XT_HLD, XT_DUP, XT_FETCH
    .word XT_1MINUS, XT_DUP, XT_TO_R
    .word XT_SWAP, XT_STORE, XT_R_FROM
    .word XT_CSTORE, XT_EXIT
END HOLD
