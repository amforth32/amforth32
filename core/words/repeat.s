# SPDX-License-Identifier: GPL-3.0-only

IMMED "repeat", REPEAT /* ( -- )(C: a1 a2 -- ) unconditional jump back to begin (over while) */
    .word XT_AGAIN
    .word XT_THEN
    .word XT_EXIT
END REPEAT
