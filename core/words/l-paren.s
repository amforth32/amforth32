# SPDX-License-Identifier: GPL-3.0-only

IMMED "(", LPAREN /* ( "ccc" -- ) skip everything up to the closing bracket on the same line */
    .word XT_DOLITERAL, 0x29
    .word XT_PARSE
    .word XT_2DROP
    .word XT_EXIT
END LPAREN
