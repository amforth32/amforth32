# SPDX-License-Identifier: GPL-3.0-only

IMMED "postpone", POSTPONE /* (C: "name" -- ) append the compilation semantics of "name" to the dictionary */
    .word XT_PARSENAME
    .word XT_FORTHRECOGNIZER
    .word XT_RECOGNIZE
    .word XT_DUP
    .word XT_TO_R
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_EXECUTE
    .word XT_R_FROM
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_COMMA
    .word XT_EXIT
END POSTPONE
