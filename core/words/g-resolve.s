# SPDX-License-Identifier: GPL-3.0-only

NONAME ">resolve", GRESOLVE /* ( addr -- ) resolve forward jump at addr to dp */
.if WANT_TRANSPILER == YES
    .word XT_TPILE_LABEL
.endif
    .word XT_MEMMODE , XT_DOCONDBRANCH , GRESOLVE0
    .word XT_QSTACK
    .word XT_DP
    .word XT_SWAP
    .word XT_STORE_I
    .word XT_EXIT

GRESOLVE0:
# compiling to ram 
    .word XT_QSTACK
    .word XT_DP
    .word XT_SWAP
    .word XT_STORE
    .word XT_EXIT
END GRESOLVE

