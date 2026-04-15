# SPDX-License-Identifier: GPL-3.0-only

IMMED "+loop", PLUSLOOP /* ( n -- )(R: loop-sys -- loop-sys | )(C: a -- )(L: i*a -- ) update loop-sys with n and jump back to do/?do or exit loop */
    .word XT_COMPILE
    .word XT_DOPLUSLOOP
    .word XT_ENDLOOP
    .word XT_EXIT
END PLUSLOOP

