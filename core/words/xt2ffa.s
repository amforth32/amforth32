# SPDX-License-Identifier: GPL-3.0-only
# : xt>nfa ( xt -- nfa )
#     \ move cell by cell towards lower address until first byte of current
#     \ cell + address of cell is equal to the xt (which is an address)
#     >r
#     r@ 
#     begin
#         4 - dup                \ a a        --
#         c@ cell / 1+ cell *    \ a n        -- 
#         over +                 \ a a'       --
#         r@                     \ a a' a''   --
#         =                      \ a f        --
#     until
#     rdrop
# ;

COLON "xt>ffa" , XT2FFA
# ( xt -- ffa ) DICT: Find FFA given XT (XT **must** have NFA)

    .word XT_XT2NFA
    .word XT_CELLMINUS
    .word XT_EXIT
