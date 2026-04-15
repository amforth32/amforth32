# SPDX-License-Identifier: GPL-3.0-only

IMMED "\\", BACKSLASH /* ( "ccc" -- ) skip everything up to the end of the current line */

    .word XT_SOURCE
    .word XT_NIP
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT
END BACKSLASH

IMMED "\\\x23", BACKSLASHHASH /* ( "ccc" -- ) skip everything up to the end of the current line */

    .word XT_SOURCE
    .word XT_NIP
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT
END BACKSLASHHASH
