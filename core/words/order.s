# SPDX-License-Identifier: GPL-3.0-only
VALUE "top" , TOP , 0
END TOP

COLON ">top" , TO_TOP
  .word XT_DOLITERAL, XT_TOP , XT_DOTO , XT_CURRENT
  .word XT_EXIT
END TO_TOP

COLON "top>" , FROM_TOP
  .word XT_DOLITERAL, XT_RAM_WORDLIST , XT_DOTO , XT_CURRENT
  .word XT_EXIT
END FROM_TOP


DEFER "cfg-order", CFG_ORDER, XT_ORDERDOTONLY /* currently configured search order */
END CFG_ORDER

DATA "order.only", ORDERDOTONLY /* RAM dictionary mode search order */
.word 4
.word XT_RAM_WORDLIST
.word XT_FORTH_WORDLIST
.word XT_ARCH_WORDLIST
.word XT_ENVIRONMENT
END ORDERDOTONLY

# This is only words assembled at build time 

DATA "order.core" , ORDERDOTCORE /* core words only search order */
.word 3
.word XT_CORE_WORDLIST
.word XT_ARCH_WORDLIST
.word XT_ENVIRONMENT
END ORDERDOTCORE

DATA "order.forth" , ORDERDOTFORTH /* FLASH dictionary mode search order */
.word 3
.word XT_FORTH_WORDLIST
.word XT_ARCH_WORDLIST
.word XT_ENVIRONMENT
END ORDERDOTFORTH

COLON "forth" , FORTH /* ( -- ) set search order to FLASH dictionary mode */
      .word XT_DOXLITERAL
      .word XT_ORDERDOTFORTH
      .word XT_DOTO
      .word XT_CFG_ORDER
      .word XT_EXIT
END FORTH

COLON "core" , CORE /* ( -- ) set search order to core words only mode */
      .word XT_DOXLITERAL
      .word XT_ORDERDOTCORE
      .word XT_DOTO
      .word XT_CFG_ORDER
      .word XT_EXIT
END CORE

COLON "only" , ONLY /* ( -- ) set search order to RAM dictionary mode */
      .word XT_DOXLITERAL
      .word XT_ORDERDOTONLY
      .word XT_DOTO
      .word XT_CFG_ORDER
      .word XT_EXIT
END ONLY

NONAME "(order)" , DOORDER

      .word XT_DUP
      .word XT_HEXDOT
      .word XT_XT2STRING
      .word XT_TYPE
      .word XT_CR
      .word XT_FALSE
      .word XT_EXIT
END DOORDER

COLON "order" , ORDER /* ( -- ) show currently configured search order */

      .word XT_DOXLITERAL
      .word XT_DOORDER
      .word XT_CFG_ORDER
      .word XT_MAPSTACK
      .word XT_DROP
      .word XT_CR
      .word XT_GET_CURRENT
      .word XT_DUP
      .word XT_HEXDOT
      .word XT_XT2STRING
      .word XT_TYPE
      STRING " (new definitions) "
      .word XT_TYPE
      .word XT_CR 
      .word XT_EXIT
END ORDER

#======================================================================
#======================================================================
# transpiling User/fth-words/get-order.f on 2024/11/17 07:41:43
# : get-order ( -- widn....wid1 n )
#     cfg-order @ 1- 0 swap do
#         cfg-order cell+ i cells + @
#     -1 +loop
#     cfg-order @
# ;

# ----------------------------------------------------------------------
COLON "get-order", GETMINUSORDER /* ( -- widn ... wid1 n ) put wids of the search order on stack  */
	.word XT_CFG_ORDER
	.word XT_FETCH
	.word XT_1MINUS
	.word XT_ZERO
	.word XT_SWAP
	.word XT_DODO
GETMINUSORDER_0002: # do
	.word XT_CFG_ORDER
	.word XT_CELLPLUS
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUSONE
	.word XT_DOPLUSLOOP,GETMINUSORDER_0002
	# +loop
GETMINUSORDER_0001: # (for ?do IF required) 
	.word XT_CFG_ORDER
	.word XT_FETCH
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================

NVARIABLE "order.table" , ORDERDOTTABLE , 9 

#======================================================================
#======================================================================
# transpiling User/fth-words/set-order.f on 2024/11/17 07:41:36
# : set-order ( widn ... wid1 n -- )
#     dup order.table !
#     0 ?do
#         order.table cell+ i cells + !
#     loop
#     ['] order.table ['] cfg-order defer!
# ;

# ----------------------------------------------------------------------
COLON "set-order", SETMINUSORDER /* ( widn ... wid1 n -- ) set search order to the list of wids on stack */
	.word XT_DUP
	.word XT_ORDERDOTTABLE
	.word XT_STORE
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SETMINUSORDER_0001
	# ?do
	.word XT_DODO
SETMINUSORDER_0002: # do
	.word XT_ORDERDOTTABLE
	.word XT_CELLPLUS
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLOOP,SETMINUSORDER_0002
	# loop
SETMINUSORDER_0001: # (for ?do IF required) 
	.word XT_DOLITERAL
	.word XT_ORDERDOTTABLE
	.word XT_DOLITERAL
	.word XT_CFG_ORDER
	.word XT_DEFER_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================

#======================================================================
#======================================================================
# transpiling previous.f on 2024/11/17 07:48:05
# : previous ( -- )
#     get-order nip 1- set-order
# ;

# ----------------------------------------------------------------------
COLON "previous", PREVIOUS /* ( -- ) drop first wordlist from the search order */
	.word XT_GETMINUSORDER
	.word XT_NIP
	.word XT_1MINUS
	.word XT_SETMINUSORDER
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================


