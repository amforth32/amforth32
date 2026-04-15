# SPDX-License-Identifier: GPL-3.0-only

COLON "wordlist", WORDLIST /* ( -- wid ) create a new, empty wordlist */

    .word XT_DP
    .word XT_DOLITERAL,4
    .word XT_DALLOT
    .word XT_DUP,XT_ZERO,XT_SWAP,XT_STORE
    .word XT_EXIT
END WORDLIST
