# SPDX-License-Identifier: GPL-3.0-only
# DIRTY
# original code base 'to', which is doing something clever and works
# for values defined in assembler but NOT from forth source, in any
# way I have tried. In .s files only XT_DOTO is ever executed, never XT_TO

# Until this is sorted, replicate the definition of `is` which seems to work for normal values,
# albeit it won't for values with custom get/set XTs.

IMMED "to", TO /* ( x "name" -- ) set value "name" to x */
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH , 1f
    .word XT_BRACKETTICK
    .word XT_COMPILE , XT_DEFER_STORE
    .word XT_FINISH
1:
    .word XT_TICK
    .word XT_DEFER_STORE
    .word XT_EXIT
END TO

# IMMED "to", TO
#     .word XT_TICK
#     .word XT_TO_BODY
#     .word XT_STATE
#     .word XT_FETCH
#     .word XT_DOCONDBRANCH, PFA_DOTO1
#       .word XT_COMPILE
#       .word XT_DOTO
#       .word XT_COMMA
#       .word XT_EXIT

NONAME "(to)", DOTO /* ( x -- ) update value identified by xt in the cell following XT_DOTO to x, skip that cell in execution */
    .word XT_R_FROM /* address of the next word in the calling word */
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R /* update return IP to skip the immediately following word when we return */
    .word XT_FETCH /* ( xt ) of the following word in the caller */
    .word XT_DOTO1
    .word XT_EXIT
END DOTO

NONAME "(to1)", DOTO1 /* ( x xt ) update value identified by xt to x */
    .word XT_CELLPLUS /* ( x xt ) */
    .word XT_DUP, XT_FETCH, XT_SWAP /* ( x ram-address pfa ) */
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_FETCH /* ( x ram-address setter-xt ) */
    .word XT_EXECUTE
    .word XT_EXIT
END DOTO1

# which leaves us free to define a "to" which overwrite the value pointed to
# by the memory location pointed to by the PFA. 

#IMMED "to", PP
IMMED "pp", PP
    .word XT_TICK
    .word XT_TO_BODY
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH, PFA_DOPP1
    .word XT_COMPILE
    .word XT_DOPP
    .word XT_COMMA
    .word XT_EXIT
END PP

COLON "(pp)", DOPP
    .word XT_R_FROM
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R
    .word XT_FETCH
    .word XT_DOPP1
    .word XT_EXIT
END DOPP

NONAME "(pp1)", DOPP1
    .word XT_FETCH
    .word XT_STORE
    .word XT_EXIT
END DOPP1
