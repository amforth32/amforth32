# SPDX-License-Identifier: GPL-3.0-only

IMMED ".\x22", DOT_QUOTE /* (C: "ccc" -- )( -- ) compiles string into dictionary to be printed at runtime */
    .word XT_SQUOTE
    .word XT_COMPILE
    .word XT_TYPE
    .word XT_EXIT
END DOT_QUOTE
