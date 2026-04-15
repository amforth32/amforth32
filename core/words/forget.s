# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling User/fth-words/forget.f on 2024/10/18 18:25:58
# 
# variable forget.prior
# 
# : (forget)
#     >r
#     2dup
# \    r@ cell + nfa>string show.stub? if
#     r@ cell + nfa>string sub-string? if
#         r@ ffa>lfa hex.
#         r@ ffa>lfa @ hex.
#         r@ hex.
#         r@ @ hex.
#         r@ ffa>nfa hex.
#         r@ ffa>nfa nfa>xt hex.
#         r@ show.xt?
#         r@ ffa>nfa nfa>string type
#         cr
#         \ now do the fixing
#         r@ ram-wordlist = if
#             r@ ffa>lfa @ ['] ram-wordlist cell+ @ !
#         else
#             r@ ffa>lfa @ forget.prior @ !
#         then
#         false
#     else
#         r@ ffa>lfa forget.prior !
#         true
#     then
#     rdrop
# ;
# 
# : forget \# ( -- "name" ) DICT: Remove a word from the RAM dictionary wordlist
#     show.header
#     parse-name
#     ['] (forget) ram-wordlist traverse-wordlist
#     2drop
# ;
# 

NOVAR "forget.prior", FORGETDOTPRIOR
END FORGETDOTPRIOR
# ----------------------------------------------------------------------
NONAME "(forget)", LPARENFORGETRPAREN 
	.word XT_TO_R
	.word XT_2DUP
	.word XT_R_FETCH
	.word XT_CELL
	.word XT_PLUS
	.word XT_NFA2STRING
	.word XT_SUBMINUSSTRINGQ
	.word XT_DOCONDBRANCH,LPARENFORGETRPAREN_0001 /* if */
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_NFA2XT
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_SHOWDOTXTQ
	.word XT_R_FETCH
	.word XT_FFA2NFA
	.word XT_NFA2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_RAM_WORDLIST
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENFORGETRPAREN_0002 /* if */
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_FETCH
	.word XT_DOLITERAL
	.word XT_RAM_WORDLIST
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOBRANCH,LPARENFORGETRPAREN_0003
LPARENFORGETRPAREN_0002: # else
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_FETCH
	.word XT_FORGETDOTPRIOR
	.word XT_FETCH
	.word XT_STORE
LPARENFORGETRPAREN_0003: # then
	.word XT_FALSE
	.word XT_DOBRANCH,LPARENFORGETRPAREN_0004
LPARENFORGETRPAREN_0001: # else
	.word XT_R_FETCH
	.word XT_FFA2LFA
	.word XT_FORGETDOTPRIOR
	.word XT_STORE
	.word XT_TRUE
LPARENFORGETRPAREN_0004: # then
	.word XT_RDROP
	.word XT_EXIT
END LPARENFORGETRPAREN

# ----------------------------------------------------------------------
COLON "forget", FORGET /* ( "subs" -- ) Remove most recent word matching substring from the RAM wordlist */
	.word XT_SHOWDOTHEADER
	.word XT_PARSENAME
	.word XT_DOLITERAL
	.word XT_LPARENFORGETRPAREN
	.word XT_RAM_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_2DROP
	.word XT_EXIT
END FORGET
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
