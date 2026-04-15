# SPDX-License-Identifier: GPL-3.0-only

NONAME "?sign", QSIGN

    .word XT_OVER 
    .word XT_CFETCH
    .word XT_DOLITERAL
    .word 45 
    .word XT_EQUAL  
    .word XT_DUP
    .word XT_TO_R
    .word XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 1
        .word XT_SLASHSTRING
1:
    .word XT_R_FROM
    .word XT_EXIT
END QSIGN
