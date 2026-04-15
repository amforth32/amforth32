@------------------------------------------------------------------------------
  CODEWORD "j", J /* ( -- n) second loop index */
@------------------------------------------------------------------------------
  savetos
  /* TODO: this should be just ldmia sp, {r0, r1}; need test */
  pop {r0,r1}
  push {r0,r1}
  add TOS, r0, r1
  NEXT
END J
