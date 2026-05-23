# SPDX-License-Identifier: GPL-3.0-only

COLON "Starting..." , STARTING /* ( -- ) display device banner */
  .word XT_DOT_VER, XT_SPACE
  .word XT_ENV_BOARD,XT_TYPE
  .word XT_SPACE, XT_ENV_BUILD_TYPE, XT_TYPE , XT_CR 
  .word XT_ENV_DOT_BUILD
  .word XT_EXIT
END STARTING

