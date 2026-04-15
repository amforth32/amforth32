# SPDX-License-Identifier: GPL-3.0-only
COLON ":code" , COLONCODE
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_DP
    .word XT_CELLPLUS
    .word XT_COMMA
    .word XT_EXIT


# ----------------------------------------------------------------------
# code; is next,
# : next,  ( -- ) 

#     XT.DONEXT here - dup        \ offset offset --
#     $00000fff and               \ offset imm12 -- 
#     swap $800 + $fffff000 and   \ imm12 (imm20 << 12 ) --

#     $297 or ,                   \ auipc t0 , 0 is $00000297
#     20 lshift $28067 or ,       \ jalr x0, 0(t0) is $28067
# ;

COLON "code;" , CODESEMI 
	.word XT_CON_DONEXT
	.word XT_DP
	.word XT_MINUS
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0xfff
	.word XT_AND
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 0x800
	.word XT_PLUS
	.word XT_DOLITERAL
	.word 0xfffff000
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x297
	.word XT_OR
	.word XT_COMMA
	.word XT_DOLITERAL
	.word 20
	.word XT_LSHIFT
	.word XT_DOLITERAL
	.word 0x28067
	.word XT_OR
	.word XT_COMMA
	.word XT_EXIT
# ----------------------------------------------------------------------

# WIP WIP WIP 
IMMED "code", CODE
    .word XT_LBRACKET
    .word XT_DP
    .word XT_CELLPLUS
    .word XT_COMMA
    .word XT_DP
    .word XT_CELLPLUS
    .word XT_COMMA
    .word XT_EXIT

# ----------------------------------------------------------------------

COLON "end-code", ENDMINUSCODE

    .word XT_DOLITERAL
	.word 0x917           # \ auipc s2 , 0
	.word XT_COMMA
	.word XT_DOLITERAL
	.word 0x1090913       # \ addi s2,s2,16
	.word XT_COMMA

    .word XT_CODESEMI
    .word XT_RBRACKET
    
	.word XT_EXIT
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
COLON "nop,", NOPCOMMA 
	.word XT_DOLITERAL
	.word 0x13     # \ addi x0 , x0, 0
	.word XT_COMMA
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "tos++,", TOSPLUSPLUSCOMMA 
	.word XT_DOLITERAL
	.word 0x198993 # \ addi s3 , s3 , 1 
	.word XT_COMMA
	.word XT_EXIT
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------

#
COLON "wdump", WDUMP 
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,WDUMP_0001 # if
	.word XT_XTGTLFA
	.word XT_DOLITERAL
	.word 0x28
	.word XT_CELLS
	.word XT_ZERO
	.word XT_DODO
WDUMP_0003: # do
	.word XT_DUP
	.word XT_I
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
	.word XT_FOUR
	.word XT_DOPLUSLOOP,WDUMP_0003 # +loop
WDUMP_0002: # (for ?do IF required) 
	.word XT_DROP
	.word XT_DOBRANCH,WDUMP_0004
WDUMP_0001: # else
	.word XT_DROP
WDUMP_0004: # then
	.word XT_EXIT

