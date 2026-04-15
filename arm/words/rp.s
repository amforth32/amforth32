@ -----------------------------------------------------------------------------
  CODEWORD "rp@", RP_FETCH /* ( -- addr ) addr is current return stack pointer */
@ -----------------------------------------------------------------------------
  savetos
  mov TOS, sp
  NEXT
END RP_FETCH

@ -----------------------------------------------------------------------------
  CODEWORD "rp!", RP_STORE /* ( addr -- ) set return stack pointer to addr */
@ -----------------------------------------------------------------------------
  mov sp, TOS
  loadtos
  NEXT
END RP_STORE

USER "rp", RP, USER_RP /* ( -- addr ) storage address of return stack pointer */
END RP
