# SPDX-License-Identifier: GPL-3.0-only

COLON ">number", TO_NUMBER /* ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) convert a string to a number c-addr2/u2 is the unconverted string */

TONUM1: .word XT_DUP,XT_DOCONDBRANCH,TONUM3
        .word XT_OVER,XT_CFETCH,XT_DIGITQ
        .word XT_ZEROEQUAL,XT_DOCONDBRANCH,TONUM2
        .word XT_DROP,XT_EXIT
TONUM2: .word XT_TO_R,XT_2SWAP,XT_BASE,XT_FETCH,XT_UDSTAR
        .word XT_R_FROM,XT_MPLUS,XT_2SWAP
        .word XT_DOLITERAL,1,XT_SLASHSTRING,XT_DOBRANCH,TONUM1
TONUM3: .word XT_EXIT

END TO_NUMBER
