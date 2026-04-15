CODEWORD "2r@", 2R_FETCH /* (R: d -- d )( -- d ) copy top 2 cells from return stack to data stack */
  savetos
  ldr TOS, [sp, #4]
  savetos
  ldr TOS, [sp]
  NEXT
END 2R_FETCH
