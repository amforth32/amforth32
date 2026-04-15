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

COLON "xt>nfa" , XT2NFA
# ( xt -- nfa ) DICT: Find NFA given XT (XT **must** have NFA)

    .word XT_TO_R
    .word XT_R_FETCH
    
PFA_XT2NFA1:
    .word XT_CELL , XT_MINUS , XT_DUP
    .word XT_CFETCH , XT_CELL , XT_SLASH , XT_1PLUS , XT_CELL , XT_STAR
    .word XT_OVER , XT_PLUS
    .word XT_R_FETCH 
    .word XT_EQUAL 
    .word XT_INVERT
PFA_XT2NFA2:
    .word XT_DOCONDBRANCH , PFA_XT2NFA3
    .word XT_DOBRANCH , PFA_XT2NFA1
        

PFA_XT2NFA3:
    .word XT_RDROP
    .word XT_EXIT 


