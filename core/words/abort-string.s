# SPDX-License-Identifier: GPL-3.0-only

IMMED "abort\x22", ABORTQUOTE /* ( f -- ) abort with the enclosed string if f is true */
    .word XT_SQUOTE
    .word XT_COMPILE
    .word XT_QABORT
    .word XT_EXIT
END ABORTQUOTE
