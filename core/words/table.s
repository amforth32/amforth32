# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling table.f on 2024/11/30 06:48:22
# : table \# ( "name" -- ) TABLE: Define table in dictionary memory
#     \ flag.table is flag.header
#     flag.table ['] flag.header defer!
#     create here cell+ , >flush
# ;
# 
# : end-table \# ( -- ) TABLE: End table in
#     align -1 , >flush
# ;
# 
# : show.table \# ( "name" -- ) TABLE: Show 0..min(EOT|15) element of table in hex
#     parse-name find-xt if
#         >body cell+ $10 0 ?do
#             dup i cells + @ -1 = if
#                 drop unloop exit
#             else
#                 dup i cells + dup hex. @ hex. cr
#             then
#         loop
#         \  01234567 01234567
#         s" ...      ..." type cr
#     then
# ;
# 
# : ntable \# ( "name" -- a ) TABLE: Define ntable in dictionary memory
#     \ flag.table is flag.header
#     flag.table ['] flag.header defer!
#     create here dup cell+ cell+ , $0 , >flush
# ;
# 
# : end-ntable \# ( a -- ) TABLE: End ntable
#     here over - 2 cells - swap cell+
#     memmode if
#         flash!
#     else
#         !
#     then
#     align -1 , >flush
# ;
# 
# : show.ntable \# ( "name" -- ) TABLE: Show all elements of ntable
#     parse-name find-xt if
#         >body @ dup cell- @ 0 ?do
#             dup i + dup hex. @ hex. cr
#         cell +loop
#         drop
#     then
# ;
# 
# 
# 

# ----------------------------------------------------------------------
COLON "table", TABLE # ( "name" -- ) TABLE: Define table in dictionary memory 
	.word XT_FLAGDOTTABLE
	.word XT_DOLITERAL
	.word XT_FLAGDOTHEADER
	.word XT_DEFER_STORE
	.word XT_CREATE
	.word XT_DP
	.word XT_CELLPLUS
	.word XT_COMMA
#	.word XT_TOFLUSH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "end-table", ENDMINUSTABLE # ( -- ) TABLE: End table
	.word XT_DALIGN
	.word XT_MINUSONE
	.word XT_COMMA
#	.word XT_TOFLUSH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show.table", SHOWDOTTABLE # ( "name" -- ) TABLE: Show 0..min(EOT|15) element of table in hex
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SHOWDOTTABLE_0001 # if
	.word XT_TO_BODY
	.word XT_CELLPLUS
	.word XT_DOLITERAL
	.word 0x10
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SHOWDOTTABLE_0002 # ?do
	.word XT_DODO
SHOWDOTTABLE_0003: # do
	.word XT_DUP
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUSONE
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTTABLE_0004 # if
	.word XT_DROP
	.word XT_UNLOOP
	.word XT_FINISH
	.word XT_DOBRANCH,SHOWDOTTABLE_0005
SHOWDOTTABLE_0004: # else
	.word XT_DUP
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
SHOWDOTTABLE_0005: # then
	.word XT_DOLOOP,SHOWDOTTABLE_0003 # loop
SHOWDOTTABLE_0002: # (for ?do IF required) 
	STRING "...      ..."
	.word XT_TYPE
	.word XT_CR
SHOWDOTTABLE_0001: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "ntable", NTABLE # ( "name" -- a ) TABLE: Define ntable in dictionary memory 
	.word XT_FLAGDOTTABLE
	.word XT_DOLITERAL
	.word XT_FLAGDOTHEADER
	.word XT_DEFER_STORE
	.word XT_CREATE
	.word XT_DP
	.word XT_DUP
	.word XT_CELLPLUS
	.word XT_CELLPLUS
	.word XT_COMMA
	.word XT_DOLITERAL
	.word 0x0
	.word XT_COMMA
#	.word XT_TOFLUSH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "end-ntable", ENDMINUSNTABLE # ( a -- ) TABLE: End ntable 
	.word XT_DP
	.word XT_OVER
	.word XT_MINUS
	.word XT_TWO
	.word XT_CELLS
	.word XT_MINUS
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,ENDMINUSNTABLE_0001 # if
#	.word XT_FLASH_STORE
	.word XT_DOBRANCH,ENDMINUSNTABLE_0002
ENDMINUSNTABLE_0001: # else
	.word XT_STORE
ENDMINUSNTABLE_0002: # then
	.word XT_DALIGN
	.word XT_MINUSONE
	.word XT_COMMA
#	.word XT_TOFLUSH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show.ntable", SHOWDOTNTABLE # ( "name" -- ) TABLE: Show all elements of ntable in hex
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SHOWDOTNTABLE_0001 # if
	.word XT_TO_BODY
	.word XT_FETCH
	.word XT_DUP
	.word XT_CELLMINUS
	.word XT_FETCH
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SHOWDOTNTABLE_0002 # ?do
	.word XT_DODO
SHOWDOTNTABLE_0003: # do
	.word XT_DUP
	.word XT_I
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
	.word XT_CELL
	.word XT_DOPLUSLOOP,SHOWDOTNTABLE_0003 # +loop
SHOWDOTNTABLE_0002: # (for ?do IF required) 
	.word XT_DROP
SHOWDOTNTABLE_0001: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
