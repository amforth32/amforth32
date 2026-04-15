# SPDX-License-Identifier: GPL-3.0-only
IMMED "for" , FOR # ( n -- ) FLOW: Execute body for (n-1)..0 
    .word XT_COMPILE , XT_TO_R
    .word XT_BEGIN
    .word XT_COMPILE , XT_R_FROM
    .word XT_COMPILE , XT_1MINUS
    .word XT_COMPILE , XT_TO_R
    .word XT_EXIT 

IMMED "next" , NEXT # ( -- ) FLOW: close of for..next
     .word XT_COMPILE , XT_R_FETCH 
     .word XT_COMPILE , XT_ZEROEQUAL
     .word XT_UNTIL
     .word XT_COMPILE , XT_RDROP
     .word XT_EXIT
