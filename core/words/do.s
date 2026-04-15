# SPDX-License-Identifier: GPL-3.0-only

IMMED "do", DO /* ( n1 n2 -- )(R: -- loop-sys )(C: -- a )(L: -- 0 ) n1=limit, n2=start do .. [+]loop */
    .word XT_COMPILE
    .word XT_DODO
    .word XT_LMARK
    .word XT_ZERO, XT_TO_L
    .word XT_EXIT
END DO
