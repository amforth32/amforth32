# SPDX-License-Identifier: GPL-3.0-only

COLON "search-wordlist", SEARCH_WORDLIST /* ( c-addr len wid -- [ 0 ] | [ xt [-1|1]] ) searches the word list wid for the word at c-addr/len */
    .word XT_TO_R
    .word XT_ZERO
    .word XT_DOLITERAL
    .word XT_ISWORD
    .word XT_R_FROM
    .word XT_TRAVERSEWORDLIST
    .word XT_DUP
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH, 1f
        .word XT_2DROP
        .word XT_DROP
        .word XT_ZERO
        .word XT_EXIT
1:
    .word XT_DUP
    .word XT_FFA2CFA
    .word XT_SWAP
    .word XT_IMMEDIATEQ
    .word XT_EXIT
END SEARCH_WORDLIST

NONAME "isword", ISWORD
    .word XT_TO_R
    .word XT_DROP
    .word XT_2DUP
    .word XT_R_FETCH
    .word XT_FFA2STRING
    .word XT_COMPARE
    .word XT_DOCONDBRANCH, 1f
        .word XT_R_FROM
        .word XT_DROP
        .word XT_ZERO
        .word XT_TRUE
        .word XT_EXIT
1:
    .word XT_2DROP
    .word XT_R_FROM
    .word XT_ZERO
    .word XT_EXIT
END ISWORD
