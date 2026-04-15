# SPDX-License-Identifier: GPL-3.0-only

NONAME "show.words", SHOWWORDS /* ( xt -- ) show words of wordlist identified by the wordlist XT */
    /* emit wordlist name */
    .word XT_DUP, XT_XT2STRING, XT_TYPE, XT_DOLITERAL, ':', XT_EMIT, XT_SPACE
    .word XT_EXECUTE, XT_SHOWWORDLIST, XT_CR /* list words */
    .word XT_FALSE
    .word XT_EXIT
END SHOWWORDS

COLON "words", WORDS /* ( -- ) list words visible in current search order */
    .word XT_DOXLITERAL
    .word XT_SHOWWORDS
    .word XT_CFG_ORDER
    .word XT_MAPSTACK
    .word XT_DROP
    .word XT_EXIT
END WORDS
