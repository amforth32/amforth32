CODEWORD "2dup", 2DUP /* ( d - d d )  duplicate top 2 cells on the stack */
  ldr r0, [DSP]
  savetos
  sub DSP, #4
  str r0, [DSP]
  NEXT
END 2DUP
