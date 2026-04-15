# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling User/fth-words/show.f on 2024/11/13 06:46:35
# 
# :~ show.xt? ( ffa -- )
#     @ $fff and case
#            flag.code     of s" CODEWORD" endof
#            flag.var      of s" VAR     " endof
#            flag.var      of s" DVAR    " endof
#            flag.colon    of s" COLON   " endof
#            flag.con      of s" CONSTANT" endof
#            flag.value    of s" VAL     " endof
#            flag.immed    of s" IMMED   " endof
#            flag.defer    of s" DEFER   " endof
#            flag.table    of s" TABLE   " endof
#  flag.init flag.value or of s" VAL+INIT" endof
#  flag.init flag.defer or of s" DEFER   " endof
#            >r s" UNKNOWN " r>
#     endcase
#     type
# ;
# 
# :~ show.what ( ffa -- )
#     >r
#     2dup
#     r@ cell + nfa>string sub-string? if
#         r@ ffa>lfa .8hex space
#         r@ ffa>lfa @ .8hex space
#         r@ .8hex space
#         r@ @ .8hex space
#         r@ ffa>nfa .8hex space
#         r@ ffa>nfa nfa>xt .8hex space
#         r@ show.xt? space
#         r@ ffa>nfa nfa>string type
#         cr
#      then
#      rdrop
#      true  \ required to keep traversing wordlist
# ;
# 
# :~ show.header
#     s" LFA..... (LFA)... FFA..... (FFA)... NFA..... XT...... (XT).... "
#     type cr
# ;
# 
# : show \# ( "name" -- ) SHOW: List words containing substring name
#     parse-name
#     show.header
#     ['] show.what forth-wordlist traverse-wordlist
#     ['] show.what ram-wordlist traverse-wordlist
#     2drop
# ;
# 
# : show.ram
#     parse-name
#     show.header
#     ['] show.what ram-wordlist traverse-wordlist
#     2drop
# ;
# 
# : show.flash
#     parse-name
#     show.header
#     ['] show.what forth-wordlist traverse-wordlist
#     2drop
# ;
# 
# : show.page
#     $ffffff00 and $10 dump
# ;
# 
# : show.buf
#     flash.buf show.page
# ;
# 
# : show.rom
#     flash.low show.page
# ;
# 
# 

# ----------------------------------------------------------------------
NONAME "show.xt?", SHOWDOTXTQ 
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xfff
	.word XT_AND
	.word XT_FLAGDOTCODE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0001 /* if */
	.word XT_DROP
	STRING "CODEWORD"
	.word XT_DOBRANCH,SHOWDOTXTQ_0002
SHOWDOTXTQ_0001: # else
	.word XT_FLAGDOTVAR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0003 /* if */
	.word XT_DROP
	STRING "VAR     "
	.word XT_DOBRANCH,SHOWDOTXTQ_0004
SHOWDOTXTQ_0003: # else
	.word XT_FLAGDOTVAR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0005 /* if */
	.word XT_DROP
	STRING "DVAR    "
	.word XT_DOBRANCH,SHOWDOTXTQ_0006
SHOWDOTXTQ_0005: # else
	.word XT_FLAGDOTCOLON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0007 /* if */
	.word XT_DROP
	STRING "COLON   "
	.word XT_DOBRANCH,SHOWDOTXTQ_0008
SHOWDOTXTQ_0007: # else
	.word XT_FLAGDOTCON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0009 /* if */
	.word XT_DROP
	STRING "CONSTANT"
	.word XT_DOBRANCH,SHOWDOTXTQ_000A
SHOWDOTXTQ_0009: # else
	.word XT_FLAGDOTVALUE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_000B /* if */
	.word XT_DROP
	STRING "VAL     "
	.word XT_DOBRANCH,SHOWDOTXTQ_000C
SHOWDOTXTQ_000B: # else
	.word XT_FLAGDOTIMMED
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_000D /* if */
	.word XT_DROP
	STRING "IMMED   "
	.word XT_DOBRANCH,SHOWDOTXTQ_000E
SHOWDOTXTQ_000D: # else
	.word XT_FLAGDOTDEFER
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_000F /* if */
	.word XT_DROP
	STRING "DEFER   "
	.word XT_DOBRANCH,SHOWDOTXTQ_0010
SHOWDOTXTQ_000F: # else
	.word XT_FLAGDOTTABLE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0011 /* if */
	.word XT_DROP
	STRING "TABLE   "
	.word XT_DOBRANCH,SHOWDOTXTQ_0012
SHOWDOTXTQ_0011: # else
	.word XT_FLAGDOTINIT
	.word XT_FLAGDOTVALUE
	.word XT_OR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0013 /* if */
	.word XT_DROP
	STRING "VAL+INIT"
	.word XT_DOBRANCH,SHOWDOTXTQ_0014
SHOWDOTXTQ_0013: # else
	.word XT_FLAGDOTINIT
	.word XT_FLAGDOTDEFER
	.word XT_OR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTXTQ_0015 /* if */
	.word XT_DROP
	STRING "DEFER   "
	.word XT_DOBRANCH,SHOWDOTXTQ_0016
SHOWDOTXTQ_0015: # else
	.word XT_TO_R
	STRING "UNKNOWN "
	.word XT_R_FROM
	.word XT_DROP
SHOWDOTXTQ_0016: # then
SHOWDOTXTQ_0014: # then
SHOWDOTXTQ_0012: # then
SHOWDOTXTQ_0010: # then
SHOWDOTXTQ_000E: # then
SHOWDOTXTQ_000C: # then
SHOWDOTXTQ_000A: # then
SHOWDOTXTQ_0008: # then
SHOWDOTXTQ_0006: # then
SHOWDOTXTQ_0004: # then
SHOWDOTXTQ_0002: # then
	.word XT_TYPE
	.word XT_EXIT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "show.what", SHOWDOTWHAT
	.word XT_TO_R
	.word XT_2DUP
	.word XT_R_FETCH
	.word XT_CELL
	.word XT_PLUS
	.word XT_NFA2STRING
	.word XT_SUBMINUSSTRINGQ
	.word XT_DOCONDBRANCH,SHOWDOTWHAT_0002 /* if */
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_FETCH
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_NFA2XT
	.word XT_DOT8HEX
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_SHOWDOTXTQ
	.word XT_SPACE
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_NFA2STRING
	.word XT_TYPE
	.word XT_CR
SHOWDOTWHAT_0002: # then
	.word XT_RDROP
	.word XT_TRUE
	.word XT_EXIT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "show.header", SHOWDOTHEADER 
	STRING "LFA..... (LFA)... FFA..... (FFA)... NFA..... XT...... (XT).... "
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show", SHOW /* ( "name" -- ) SHOW: List words containing substring name */
	.word XT_PARSENAME
	.word XT_SHOWDOTHEADER
	.word XT_DOLITERAL
	.word XT_SHOWDOTWHAT
	.word XT_FORTH_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_DOLITERAL
	.word XT_SHOWDOTWHAT
	.word XT_RAM_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_2DROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show.ram", SHOWDOTRAM 
	.word XT_PARSENAME
	.word XT_SHOWDOTHEADER
	.word XT_DOLITERAL
	.word XT_SHOWDOTWHAT
	.word XT_RAM_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_2DROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show.flash", SHOWDOTFLASH 
	.word XT_PARSENAME
	.word XT_SHOWDOTHEADER
	.word XT_DOLITERAL
	.word XT_SHOWDOTWHAT
	.word XT_FORTH_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_2DROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "show.page", SHOWDOTPAGE 
	.word XT_DOLITERAL
	.word 0xffffff00
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x10
	.word XT_DUMP
	.word XT_EXIT
#======================================================================
