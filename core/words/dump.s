# SPDX-License-Identifier: GPL-3.0-only
# RAM dump is byte oriented:
# 00B0 BD 3E 55 33 5B E6 C4 9B 4A 63 72 20 63 72 20 24   .>U3[...Jcr.cr.$
# 00C0 62 30 20 32 30 20 64 75 6D 70 20 63 72 20 63 72   b0.20.dump.cr.cr

#: ?ascii ( char -- printable-char )
#  dup $20 < if drop $2e
#           else dup $7e > 
#                if drop $2e then
#           then ;


COLON "?ascii", QASCII /* ( c -- f ) f is true if c is printable character */
    .word XT_DUP, XT_DOLITERAL,0x20,XT_LESS
    .word XT_DOCONDBRANCH,PFA_QASCII1
	.word XT_DROP, XT_DOLITERAL,0x2e
	.word XT_DOBRANCH, PFA_QASCII2
PFA_QASCII1:
	.word XT_DUP, XT_DOLITERAL, 0x7e,XT_GREATER
	.word XT_DOCONDBRANCH,PFA_QASCII2
	.word XT_DROP, XT_DOLITERAL,0x2e
PFA_QASCII2:
    .word XT_EXIT
END QASCII

# MFD COLON ".2hex", DOT2HEX 
#     .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
#     .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP_G,XT_TYPE
#     .word XT_R_FROM,XT_BASE,XT_STORE
#     .word XT_EXIT

# #: .2hex base @ >r hex s>d <# # # #> type r> base ! ;
# #: .4hex base @ >r hex s>d <# # # # # #> type r> base ! ;

# MFD COLON ".4hex", DOT4HEX
#     .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
#     .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
#     .word XT_SHARP_G,XT_TYPE
#     .word XT_R_FROM,XT_BASE,XT_STORE
#     .word XT_EXIT

COLON ".8hex", DOT8HEX /* ( u -- ) display u as 8 digit hex */
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
    .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT
END DOT8HEX
     
COLON "x.", XDOT /* ( u -- ) display u without trailing space */
    .word XT_S2D,XT_SWAP,XT_OVER,XT_DABS
    .word XT_L_SHARP,XT_SHARP_S
    .word XT_ROT,XT_SIGN
    .word XT_SHARP_G,XT_TYPE
    .word XT_EXIT
END XDOT

COLON "2x.", 2XDOT /* ( u -- ) display u as 2 digit hex */
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX  
    .word XT_DOLITERAL, 0 
    .word XT_L_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT
END 2XDOT

COLON "8x.", 8XDOT /* ( u -- ) display u as 8 digit hex no space */
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX  
    .word XT_DOLITERAL, 0 
    .word XT_L_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT
END 8XDOT

COLON "hex.", HEXDOT /* ( u -- ) output u as unsigned 32 bit hex  */
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX  
    .word XT_DOLITERAL, 0 
    .word XT_L_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE,XT_SPACE 
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT
END HEXDOT

COLON "r.", RDOT /* ( n -- ) output n as 32 bit binary with crib  */
    STRING "..28 ..24 ..20 ..16 ..12 ..08 ..04 ..00"
    .word XT_TYPE,XT_CR
    .word XT_RDOTDOT
    .word XT_EXIT
END RDOT

COLON "r..", RDOTDOT /* ( n -- ) output n as 32 bit binary  */
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_DOLITERAL,2,XT_BASE,XT_STORE 
    .word XT_DOLITERAL, 0 
    .word XT_L_SHARP
    .word XT_DOLITERAL,0x07,XT_ZERO,XT_DODO
RDOTDOT_0001:    
    .word XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP,XT_DOLITERAL,0x20,XT_HOLD 
    .word XT_DOLOOP, RDOTDOT_0001
    .word XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT


#: dump ( addr count -- )
#  swap $f invert and $swap
#  cr 0
#  do dup .8hex space
#     $10 0 do dup i + c@ .2hex space loop 2 spaces
#     $10 0 do dup i + c@ ?ascii emit loop
#     $10 + cr 
#  $10 +loop drop ;

COLON "dump" , DUMP /* ( a u -- ) dump u lines of 16 bytes including [a] */
#    .word XT_SWAP,XT_DOLITERAL, 0xf, XT_INVERT,XT_AND,XT_SWAP
    .word XT_SWAP,XT_DOLITERAL, 0x3, XT_INVERT,XT_AND,XT_SWAP
    .word XT_CR,XT_ZERO
    STRING "-------- 00--------- 04--------- 08--------- 0C---------"
    .word XT_TYPE, XT_CR
    .word XT_DODO

PFA_DUMP0:
    .word XT_DUP,XT_8XDOT,XT_SPACE

    .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO
PFA_DUMP1:
    .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_2XDOT,XT_SPACE,XT_DOLOOP,PFA_DUMP1

PFA_DUMP2:
    .word XT_SPACE, XT_SPACE, XT_SPACE, XT_SPACE

    .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO
PFA_DUMP3:
    .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_QASCII,XT_EMIT,XT_DOLOOP,PFA_DUMP3

PFA_DUMP4:
    .word XT_DOLITERAL,0x10,XT_PLUS,XT_CR,XT_DOLOOP,PFA_DUMP0

    .word XT_DROP,XT_EXIT
END DUMP

#COLON "dump", DUMP
#    .word XT_SWAP,XT_DOLITERAL, 0xfffffff0, XT_AND,XT_SWAP
#    .word XT_CR,XT_ZERO,XT_DODO
#PFA_DUMP0:
#      .word XT_DUP,XT_DOT8HEX,XT_SPACE
#      .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO
#  PFA_DUMP1:
#        .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_DOT2HEX,XT_SPACE,XT_DOLOOP,PFA_DUMP1
#  PFA_DUMP2:
#      .word XT_SPACE,XT_SPACE
#      .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO
#  PFA_DUMP3:
#        .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_QASCII, XT_EMIT,XT_DOLOOP,PFA_DUMP3
#  PFA_DUMP4:

#      .word XT_DOLITERAL,0x10,XT_PLUS,XT_CR
#PFA_DUMP5:
#    .word XT_DOLITERAL,0x10,XT_DOPLUSLOOP,PFA_DUMP0
#.word XT_DROP,XT_EXIT
