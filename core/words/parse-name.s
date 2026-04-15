# SPDX-License-Identifier: GPL-3.0-only

COLON "parse-name", PARSENAME /* ( "name" -- s ) parse whitespace delimited string from SOURCE */
/* Returns string address within SOURCE. */
    .word XT_BL
    .word XT_SKIPSCANCHAR
    .word XT_EXIT
END PARSENAME

NONAME "skipscanchar", SKIPSCANCHAR /* ( c "name" -- s ) */
    .word XT_TO_R
    .word XT_SOURCE 
    .word XT_TO_IN 
    .word XT_FETCH 
    .word XT_SLASHSTRING 
    /* ( ca u ) the unread part of source */
    /* skip spaces at the beginning */
    .word XT_R_FETCH
    .word XT_CSKIP
    /* scan to the next space */
    .word XT_R_FROM
    .word XT_CSCAN
    /* update >in */
    .word XT_2DUP
    .word XT_PLUS
    .word XT_SOURCE 
    .word XT_DROP
    .word XT_MINUS
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT
END SKIPSCANCHAR
