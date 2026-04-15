# SPDX-License-Identifier: GPL-3.0-only
# : mset ( mask a -- )
#     dup      \ mask a a
#     @        \ mask a n
#     rot      \ a m mask
#     or       \ a n'
#     swap     \ n' a
#     !        \ --
# ;

# : mclr ( mask a -- )
#     dup      \ mask a a 
#     @        \ mask a n
#     rot      \ a n mask
#     invert   \ a n mask'
#     and      \ a n'
#     swap     \ n' a
#     !        \ --
# ;

# : mtog ( mask a -- )
#     dup      \ mask a a
#     @        \ mask a n
#     rot      \ a n mask
#     xor      \ a n'
#     swap     \ n' a
#     !        \ --
# ;

# : m4fix ( mask pin port -- )
#     >r >r                            \ R: -- port pin
#     dup                              \ -- mask mask
#     invert %1111 and
#     r@ 4 * lshift
# \   dup r. cr 
#     swap
#     r@ 4 * lshift                    \ mask-clr mask-set --
# \   dup r. cr
#     rdrop
#     r@ mset  \ 
#     r> mclr
# ;

COLON "mset", MSET
# ( mask a -- ) MEM: set bits in [a] if bits set in mask
    .WORD XT_DUP , XT_FETCH , XT_ROT , XT_OR , XT_SWAP , XT_STORE, XT_EXIT  

COLON "mclr", MCLR
# ( mask a -- ) MEM: clear bits in [a] if bits set in mask
    .WORD XT_DUP , XT_FETCH , XT_ROT , XT_INVERT,  XT_AND, XT_SWAP , XT_STORE, XT_EXIT  

COLON "mtog", MTOG
# ( mask a -- ) MEM: toggle bits in [a] if bits set in mask
    .WORD XT_DUP , XT_FETCH , XT_ROT , XT_XOR , XT_SWAP , XT_STORE, XT_EXIT  

COLON "m4fix", M4FIX
# ( mask n a -- ) MEM: fix a 4 bit patten in [a] starting at bit 4n in [a]
    .WORD XT_TO_R , XT_TO_R , XT_DUP , XT_INVERT 
    .word XT_DOLITERAL , 0xF , XT_AND
    .WORD XT_R_FETCH , XT_CELL , XT_STAR , XT_LSHIFT
    .WORD XT_SWAP
    .WORD XT_R_FETCH , XT_CELL , XT_STAR , XT_LSHIFT
    .WORD XT_RDROP
    .WORD XT_R_FETCH , XT_MSET
    .WORD XT_R_FROM  , XT_MCLR
    .WORD XT_EXIT 
