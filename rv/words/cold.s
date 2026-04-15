# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "cold", COLD /* ( i*x -- )(R: j*y -- ) assembler part of the boot sequence, starting the VM */
/* This is assembly part of the startup sequence that creates the basic runtime environment for the virtual machine.
   It sets up the hardware, the stack pointers and the forth registers for the WARM word, 
   then boots the virtual machine by jumping to the inner interpreter.

   MCUs may override this to inject additional initialization at specific points.
*/

  la s5, RAM_upper_returnstack
  la s4, RAM_upper_datastack # TW hack
.if WANT_DEBUGGER == YES
  mv s7, zero # zero out the DEBUG register
.endif

  lui  s1,      %hi(XT_WARM)
  addi s1, s1,  %lo(XT_WARM)
  # la s1, XT_WARM

  j DO_EXECUTE
END COLD
