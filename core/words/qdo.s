# SPDX-License-Identifier: GPL-3.0-only

IMMED "?do", QDO /* ( n1 n2 -- )(R: -- | loop-sys )(C: -- a1 )(L: -- 0 a2 ) n1=limit, n2=start ?do .. [+]loop */
    .word XT_COMPILE
    .word XT_QDOCHECK
    .word XT_IF
    .word XT_DO
    .word XT_SWAP
    .word XT_TO_L
    .word XT_EXIT
END QDO

COLON "(qdocheck)", QDOCHECK
    .word XT_2DUP
    .word XT_EQUAL
    .word XT_DUP
    .word XT_TO_R
    .word XT_DOCONDBRANCH, PFA_QDOCHECK1
    .word XT_2DROP
PFA_QDOCHECK1:
    .word XT_R_FROM
    .word XT_INVERT
    .word XT_EXIT
END QDOCHECK
