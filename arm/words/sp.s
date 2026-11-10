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

COLON "sp0", SP0 /* ( -- addr ) start of the data stack */
    .word XT_UP_FETCH, XT_DOLITERAL, USER_SP0, XT_PLUS, XT_EXIT
END SP0
