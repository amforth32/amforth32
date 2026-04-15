# SPDX-License-Identifier: GPL-3.0-only

IMMED "loop", LOOP /* ( -- )(R: loop-sys -- loop-sys | )(C: a -- )(L: i*a -- ) update loop-sys and jump back to do/?do or exit loop */
    .word XT_COMPILE
    .word XT_DOLOOP
    .word XT_ENDLOOP
    .word XT_EXIT
END LOOP
