# SPDX-License-Identifier: GPL-3.0-only

COLON "show-wordlist", SHOWWORDLIST /* ( wid -- ) list words in wordlist wid */
    .word XT_DOLITERAL
    .word XT_SHOWWORD
    .word XT_SWAP
    .word XT_TRAVERSEWORDLIST
    .word XT_EXIT
END SHOWWORDLIST

NONAME "show.word", SHOWWORD
    .word XT_FFA2STRING
    .word XT_TYPE
    .word XT_SPACE
#    .word XT_CR
    .word XT_TRUE
    .word XT_EXIT
END SHOWWORD
