# SPDX-License-Identifier: GPL-3.0-only

COLON "find-xt", FINDXT /* ( c-addr u -- 0 | xt -1 | xt 1 ) search for word s1, return xt if found */
    .word XT_DOLITERAL
    .word XT_DOFINDXT
    .word XT_CFG_ORDER
    .word XT_MAPSTACK
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH, 1f
      .word XT_2DROP
      .word XT_ZERO
1:
    .word XT_EXIT
END FINDXT

NONAME "(find-xt)", DOFINDXT
    .word XT_TO_R
    .word XT_2DUP
    .word XT_R_FROM, XT_EXECUTE
    .word XT_SEARCH_WORDLIST
    .word XT_DUP
    .word XT_DOCONDBRANCH, 1f
      .word XT_TO_R
      .word XT_NIP
      .word XT_NIP
      .word XT_R_FROM
      .word XT_TRUE
1:
    .word XT_EXIT
END DOFINDXT

