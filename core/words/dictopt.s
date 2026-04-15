# SPDX-License-Identifier: GPL-3.0-only
COLON "ffa>nfa" , FFA2NFA
  .word XT_CELLPLUS
  .word XT_EXIT 

COLON "lfa>ffa" , LFA2FFA
  .word XT_CELLPLUS
  .word XT_EXIT 

COLON "nfa>xt" , NFA2XT
  .word XT_DUP   , XT_CFETCH , XT_CELL , XT_SLASH
  .word XT_1PLUS , XT_CELL   , XT_STAR , XT_PLUS
  .word XT_EXIT

COLON "nfa>string" , NFA2STRING
  .WORD XT_DUP , XT_CFETCH , XT_SWAP 
  .word XT_1PLUS , XT_SWAP
  .word XT_EXIT
