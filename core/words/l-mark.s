# SPDX-License-Identifier: GPL-3.0-only

NONAME "<mark", LMARK /* ( -- addr ) remember dp as address of a backward jump */
    .word XT_DP
.if WANT_TRANSPILER == YES
    .word XT_TPILE_LABEL
.endif
    .word XT_EXIT
END LMARK
