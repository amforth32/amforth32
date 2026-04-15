# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
# transpiling alias.f on 2026/03/30 13:24:35
# : synonym
#     flag.alias to flag.header (create) reveal
#     parse-name find-xt if
#         >r r@ xt>ffa @ case
#             flag.code  of r> @ , endof
#             flag.colon of compile label DOALIAS r> cell+ , endof
#             flag.alias of rdrop symbol EALIALI throw endof
#             rdrop symbol EUNSUP throw
#         endcase
#     else
#         rdrop symbol EUNDEF throw
#     then
# ;

# ----------------------------------------------------------------------
COLON "synonym", SYNONYM /* ( "<spaces>new-name" "name" -- ) create alias of existing word */
	.word XT_FLAGDOTALIAS
	.word XT_DOTO
	.word XT_FLAGDOTHEADER
	.word XT_DOCREATE
	.word XT_REVEAL
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SYNONYM_0001 /* if */
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2FFA
	.word XT_FETCH
	.word XT_FLAGDOTCODE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SYNONYM_0002 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_FETCH
	.word XT_COMMA
	.word XT_DOBRANCH,SYNONYM_0003
SYNONYM_0002: /* else */
	.word XT_FLAGDOTCOLON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SYNONYM_0004 /* if */
	.word XT_DROP
	.word XT_COMPILE
	.word DOALIAS
	.word XT_R_FROM
	.word XT_CELLPLUS
	.word XT_COMMA
	.word XT_DOBRANCH,SYNONYM_0005
SYNONYM_0004: /* else */
	.word XT_FLAGDOTALIAS
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SYNONYM_0006 /* if */
	.word XT_DROP
	.word XT_RDROP
	.word XT_DOLITERAL
	.word EALIALI
	.word XT_THROW
	.word XT_DOBRANCH,SYNONYM_0007
SYNONYM_0006: /* else */
	.word XT_RDROP
	.word XT_DOLITERAL
	.word EUNSUP
	.word XT_THROW
	.word XT_DROP
SYNONYM_0007: /* then */
SYNONYM_0005: /* then */
SYNONYM_0003: /* then */
	.word XT_DOBRANCH,SYNONYM_0008
SYNONYM_0001: /* else */
	.word XT_RDROP
	.word XT_DOLITERAL
	.word EUNDEF
	.word XT_THROW
SYNONYM_0008: /* then */
	.word XT_EXIT
END SYNONYM
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================

COLONALIAS "alias" , ALIAS , SYNONYM /* ( "<spaces>new-name" "name" -- ) create alias of existing word */
END ALIAS
