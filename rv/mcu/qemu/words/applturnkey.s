# SPDX-License-Identifier: GPL-3.0-only
COLON "wch-turnkey", APPLTURNKEY # ( -- ) SYSTEM: 

#  .word XT_LED_INIT
#  .word XT_MINUSLED

  .word XT_DECIMAL

  .word XT_USART1_INIT

  .word XT_DOT_VER, XT_SPACE
  .word XT_ENV_BOARD,XT_TYPE
  .word XT_SPACE, XT_ENV_BUILD_TYPE, XT_TYPE , XT_CR 
  .word XT_ENV_DOT_BUILD

# .word XT_BLINK

# fixing :noname as first command

.ifnb YES
  .word XT_ZERO
  .word XT_NEWEST
  .word XT_STORE

  .word XT_ZERO
  .word XT_NEWEST
  .word XT_CELLPLUS
  .word XT_STORE
.endif

.word XT_EXIT

