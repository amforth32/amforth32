# SPDX-License-Identifier: GPL-3.0-only

IMMED "while", WHILE /* ( f -- )(C: a1 -- a2 a1 ) if f is false jump past repeat */
    .word XT_IF
    .word XT_SWAP
    .word XT_EXIT
END WHILE
