# SPDX-License-Identifier: GPL-3.0-only

COLON "/string", SLASHSTRING /* ( addr1 u1 n -- addr2 u2 ) adjust string from addr1 to addr1+n, reduce length from u1 to u2 by n */

    .word XT_ROT
    .word XT_OVER
    .word XT_PLUS
    .word XT_ROT
    .word XT_ROT
    .word XT_MINUS
    .word XT_EXIT

END SLASHSTRING
