@------------------------------------------------------------------------------
  CODEWORD "r@", R_FETCH /* (R: x -- x )( -- x ) copy top of return stack to data stack */
@------------------------------------------------------------------------------
  savetos
  ldr TOS, [sp]
  NEXT
END R_FETCH
