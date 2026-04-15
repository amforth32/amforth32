# SPDX-License-Identifier: GPL-3.0-only

COLON "toupper", TOUPPER /* ( c -- C ) if c is a lowercase letter convert it to uppercase */
    .word XT_DUP 
    .word XT_DOLITERAL 
    .word 'a' 
    .word XT_DOLITERAL 
    .word 'z'+1
    .word XT_WITHIN 
    .word XT_DOCONDBRANCH,PFA_TOUPPER0
    .word XT_DOLITERAL
    .word 223 
    .word XT_AND 
PFA_TOUPPER0:
    .word XT_EXIT 
END TOUPPER
