# SPDX-License-Identifier: GPL-3.0-only
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
