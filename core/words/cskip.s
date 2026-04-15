# SPDX-License-Identifier: GPL-3.0-only

COLON "cskip", CSKIP /* ( addr1 n1 c -- addr2 n2 ) skips leading occurrences of c in s1, s2 starts at the 1st non-c character */

    .word XT_TO_R
PFA_CSKIP1:
    .word XT_DUP      
    .word XT_DOCONDBRANCH, PFA_CSKIP2
    .word XT_OVER         
    .word XT_CFETCH       
    .word XT_R_FETCH      
    .word XT_EQUAL        
    .word XT_DOCONDBRANCH, PFA_CSKIP2
    .word XT_DOLITERAL,1
    .word XT_SLASHSTRING
    .word XT_DOBRANCH, PFA_CSKIP1
PFA_CSKIP2:
    .word XT_R_FROM
    .word XT_DROP          
    .word XT_EXIT

END CSKIP
