# SPDX-License-Identifier: GPL-3.0-only

IMMED "[\x27]", BRACKETTICK /* (C: "name" -- xt ) parse "name" to XT at compile time */
    .word XT_TICK
#    .word XT_LITERAL   # replaced by below so that save can find xt as literal
    # and translate the address (from RAM dict to FLASH dict) 
    .word XT_XLITERAL   
    .word XT_EXIT
END BRACKETTICK
