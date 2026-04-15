# SPDX-License-Identifier: GPL-3.0-only

#======================================================================
#======================================================================
# transpiling ../../../../forth/immed.f on 2026/03/20 11:56:36
# 
# : :immed \# ( -- ) define an immediate word (for mcu that's can't use immediate)
#     flag.immed is flag.header (create) :noname drop
# ;
# 
# : immediate \# ( -- ) set FFA of last created word to immediate
#         memmode if
#             symbol EUNSUP throw
#         else
#             flag.immed newest @ !
#         then
# ;
# 
# : [defined]
#     parse-name find-xt 0= if false else drop true then
# ; immediate
# 
#

# ----------------------------------------------------------------------
COLON ":immed", COLONIMMED /* ( -- ) define an immediate word (for mcu that's can't use immediate) */
	.word XT_FLAGDOTIMMED
	.word XT_DOXLITERAL
	.word XT_FLAGDOTHEADER
	.word XT_DEFER_STORE
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WORD
.endif
	.word XT_DOCREATE
	.word XT_COLONNONAME
	.word XT_DROP
	.word XT_EXIT
END COLONIMMED
# ----------------------------------------------------------------------
COLON "immediate", IMMEDIATE /* ( -- ) set FFA of last created word to immediate (RAM words only) */
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,IMMEDIATE_0001 /* if */
	.word XT_DOLITERAL
	.word EUNSUP
	.word XT_THROW
	.word XT_DOBRANCH,IMMEDIATE_0002
IMMEDIATE_0001: /* else */
	.word XT_FLAGDOTIMMED
	.word XT_NEWEST
	.word XT_FETCH
	.word XT_STORE
IMMEDIATE_0002: /* then */
	.word XT_EXIT
END IMMEDIATE
# ----------------------------------------------------------------------
IMMED "[defined]", LBRACKDEFINEDRBRACK  /* ( "name" -- f ) f is true if name defined */
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,LBRACKDEFINEDRBRACK_0001 /* if */
	.word XT_FALSE
	.word XT_DOBRANCH,LBRACKDEFINEDRBRACK_0002
LBRACKDEFINEDRBRACK_0001: /* else */
	.word XT_DROP
	.word XT_TRUE
LBRACKDEFINEDRBRACK_0002: /* then */
	.word XT_EXIT
END LBRACKDEFINEDRBRACK
# ----------------------------------------------------------------------

IMMED "[undefined]" , LBRACKUNDEFINEDRBRACK /* ( "name -- f ) f is true if name undefined */
    .word XT_LBRACKDEFINEDRBRACK
    .word XT_NOT
    .word XT_EXIT
END LBRACKUNDEFINEDRBRACK

# ----------------------------------------------------------------------
#=====================================================================
#======================================================================


# COLON "immediate", IMMEDIATE /* ( -- ) set immediate flag for the most recent word definition (RAM words only) */
#     .word XT_GET_CURRENT,XT_EXECUTE
#     .word XT_DUP, XT_DOLITERAL,Flag_immediate
#     .word XT_ROT, XT_FETCH, XT_OR, XT_SWAP, XT_STORE
#     .word XT_EXIT
# END IMMEDIATE
