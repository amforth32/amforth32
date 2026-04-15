CODEWORD "2r>", 2R_FROM /* (R: d -- )( -- d ) move top 2 cells from return stack to data stack */
  savetos
  pop {TOS}
  pop {r0}
  sub DSP, #4
  str r0, [DSP]
  NEXT
END 2R_FROM
