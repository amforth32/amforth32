# SPDX-License-Identifier: GPL-3.0-only

COLON "sign", SIGN /* ( n -- ) PNO: place minus at HLD if n is negative */
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH
    .word PFA_SIGN1
    .word XT_DOLITERAL
    .word 45 
    .word XT_HOLD
PFA_SIGN1:
    .word XT_EXIT
END SIGN
