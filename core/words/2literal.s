# SPDX-License-Identifier: GPL-3.0-only

IMMED "2literal", 2LITERAL /* (C: d -- ) compile code that will append cell pair literal to the dictionary */
    .word XT_SWAP
    .word XT_LITERAL
    .word XT_LITERAL
    .word XT_EXIT
END 2LITERAL
