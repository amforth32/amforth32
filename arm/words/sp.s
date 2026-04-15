@ -----------------------------------------------------------------------------
  CODEWORD "sp@", SP_FETCH /* ( -- addr ) addr is current data stack pointer */
@ -----------------------------------------------------------------------------
  savetos
  mov TOS, DSP
  NEXT
END SP_FETCH

@ -----------------------------------------------------------------------------
  CODEWORD "sp!", SP_STORE /* ( addr -- ) set data stack pointer to addr */
@ -----------------------------------------------------------------------------
  mov DSP, TOS
  loadtos
  NEXT
END SP_STORE

USER "sp", SP, USER_SP /* ( -- addr ) storage address of data stack pointer */
END SP

USER "sp0", SP0, USER_SP0 /* ( -- addr ) storage address of initial data stack pointer */
END SP0
