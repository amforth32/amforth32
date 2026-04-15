# SPDX-License-Identifier: GPL-3.0-only

COLON "init-ram", INIT_RAM /* ( -- ) startup/reset RAM initialization */
    .word XT_DOLITERAL, RAM_lower_userarea, XT_UP_STORE /* set UP */
    .word XT_DOLITERAL, XT_FORTH_WORDLIST, XT_TO_BODY,XT_DUP,XT_CELLPLUS,XT_FETCH,XT_SWAP,XT_FETCH,XT_STORE
    .word XT_DOLITERAL, XT_DOINITS, XT_FORTH_WORDLIST, XT_TRAVERSEWORDLIST /* initialize values and defers */
    .word XT_EXIT
END INIT_RAM

NONAME "(inits)", DOINITS /* ( ffa -- f ) initialize any value or defer (flag_init) with its default value */
    .word XT_DUP
    .word XT_FETCH, XT_DOLITERAL, Flag_init, XT_DUP,XT_ROT,XT_AND,XT_EQUAL
    .word XT_DOCONDBRANCH, 1f
        .word XT_FFA2CFA 
        .word XT_TO_BODY,XT_DUP,XT_CELLPLUS, XT_FETCH, XT_SWAP, XT_FETCH, XT_STORE
        .word XT_TRUE
        .word XT_EXIT
1:
    .word XT_DROP
    .word XT_TRUE
    .word XT_EXIT
END DOINITS
