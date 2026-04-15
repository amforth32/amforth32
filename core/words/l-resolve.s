# SPDX-License-Identifier: GPL-3.0-only

NONAME "<resolve", LRESOLVE /* ( addr -- ) compile addr as a target of backward jump */
    .word XT_QSTACK
.if WANT_TRANSPILER == YES
    .word XT_TPILE_BACK
.endif
    .word XT_COMMA
    .word XT_EXIT
END LRESOLVE
