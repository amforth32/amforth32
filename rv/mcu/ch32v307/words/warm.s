# SPDX-License-Identifier: GPL-3.0-only

# COLON "warm.reload" , WARM_RELOAD
#   .word XT_ROM_TO_RAM

#   # update forth-wordlist 
#   .word XT_FLASH_BUF , XT_FETCH
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_FORTH_WORDLIST

#   # update flash pointer 
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_CELLPLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_CELLPLUS , XT_CELLPLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_FLASH_P

#   # update flash_dp
#   .word XT_FLASH_P , XT_DOTO , XT_DP_FLASH 

#   # update ram pool pointer
#   .word XT_FLASH_BUF , XT_DOLITERAL , 4 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_DOLITERAL , 5 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_RAM_POOLP

#   # update rom pool pointer
#   .word XT_FLASH_BUF , XT_DOLITERAL , 6 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_DOLITERAL , 7 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_ROM_P

#   .word XT_EXIT

COLON "warm", WARM /* ( -- ) high level part of the boot sequence, VM is running */
/* This is the high level part of the boot sequence with the VM already running.
  After initializations calls TURNKEY and if TURNKEY returns calls QUIT
  to enter the endless outer interpreter loop.
  When called from within forth it is the equivalent of a soft RESET.

  MCUs may override this to inject additional initialization at specific points
*/

  /* initialize values and defers to their defaults */
  .word XT_INIT_RAM

.if WANT_DEBUGGER == YES
  /* initialize debugger to disabled state,
    needs UP initialized so after INIT_RAM! */
  .word XT_DEBUGMINUS
.endif

.if WANT_TRANSPILER == YES
  /* initialize transpiler to disabled state */
  .word XT_TPILEMINUS
.endif

  /* unlock flash system */
  .word XT_FLASHDOTUNLOCK                                                            

.if WANT_USB_OPERATOR
  .word XT_INIT_USB_OPERATOR
.endif


  /* initialize pvalue system */
  .word XT_QFIRST_BOOT, XT_DOCONDBRANCH, 1f
    .word XT_PVARENA1, XT_DOTO, XT_PVARENA, XT_PV_RESET_HARD
    .word XT_DOBRANCH, 2f 
1: /* else */
    .word XT_PV_INIT
2:
  /* check and mark first-boot done */
  .word XT_QFIRST_BOOT, XT_DOCONDBRANCH, 1f
    .word XT_FIRST_BOOT_DONE
1:
  /* find the end of the used flash and set DP;
    do it after first-boot-done so that the first-boot page is erased already */
  .word XT_INIT_DP_FLASH

  .word XT_LBRACKET  
  .word XT_TURNKEY    
  .word XT_QUIT       
  .word XT_EXIT       
END WARM

.if WANT_USB_OPERATOR
NONAME "init.usb.operator", INIT_USB_OPERATOR
  /* DEFER "emit", EMIT, XT_USB_EMIT_PAUSE */
  .word XT_DOLITERAL, XT_USB_EMIT_PAUSE, XT_DOLITERAL, XT_EMIT, XT_CELLPLUS, XT_FETCH, XT_STORE
  /* DEFER "emit?",EMITQ, XT_USB_EMITQ */
  .word XT_DOLITERAL, XT_USB_EMITQ, XT_DOLITERAL, XT_EMITQ, XT_CELLPLUS, XT_FETCH, XT_STORE
  /* DEFER "key", KEY, XT_USB_KEY_PAUSE */
  .word XT_DOLITERAL, XT_USB_KEY_PAUSE, XT_DOLITERAL, XT_KEY, XT_CELLPLUS, XT_FETCH, XT_STORE
  /* DEFER "key?",KEYQ, XT_USB_KEYQ */
  .word XT_DOLITERAL, XT_USB_KEYQ, XT_DOLITERAL, XT_KEYQ, XT_CELLPLUS, XT_FETCH, XT_STORE
  .word XT_EXIT
END INIT_USB_OPERATOR
.endif
