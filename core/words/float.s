# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling float.f on 2024/10/19 17:06:57
# $3f800000 constant f.1
# $40000000 constant f.2
# $41200000 constant f.10
# $3f000000 constant f.h
# $3e800000 constant f.q
# $3f2aaaab constant f.t
# 
# \ : >f ( "name" )
# \     parse-name dup >r f.in swap move 0 r> f.in + c! f.strtof
# \ ;
# 
# 
# : float.fmt! ( ca cu -- )
#     dup >r
#     float.fmt c!                \ write cu for a string in forth
#     $0 float.fmt r@ + char+ c!  \ write \0 for a string in C
#     float.fmt char+ r> move     \ copy to b[1]
# ;
# 
# : >f ( ca cu -- )
#     dup >r
#     float.in c!                \ write cu for a string in forth
#     $0 float.in r@ + char+ c!  \ write \0 for a string in C
#     float.in char+ r> move     \ copy to b[1]
#     (>f)                       \ float f(ish)
# 
#     0= if -50 throw then
# ;
# 

CONSTANT "f.1",FDOT1,0x3f800000
CONSTANT "f.2",FDOT2,0x40000000
CONSTANT "f.10",FDOT10,0x41200000
CONSTANT "f.h",FDOTH,0x3f000000
CONSTANT "f.q",FDOTQ,0x3e800000
CONSTANT "f.t",FDOTT,0x3f2aaaab
# ----------------------------------------------------------------------
COLON "float.fmt!", FLOATDOTFMTBANG 
	.word XT_DUP
	.word XT_TO_R
	.word XT_FLOAT_FMT
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 0x0
	.word XT_FLOAT_FMT
	.word XT_R_FETCH
	.word XT_PLUS
	.word XT_CHARPLUS
	.word XT_CSTORE
	.word XT_FLOAT_FMT
	.word XT_CHARPLUS
	.word XT_R_FROM
	.word XT_MOVE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON ">f", GTF 
	.word XT_DUP
	.word XT_TO_R
	.word XT_FLOAT_IN
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 0x0
	.word XT_FLOAT_IN
	.word XT_R_FETCH
	.word XT_PLUS
	.word XT_CHARPLUS
	.word XT_CSTORE
	.word XT_FLOAT_IN
	.word XT_CHARPLUS
	.word XT_R_FROM
	.word XT_MOVE
	.word XT_RTEST
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,GTF_0001 # if
	.word XT_DOLITERAL, -50, XT_THROW
GTF_0001: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
