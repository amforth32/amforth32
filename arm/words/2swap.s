CODEWORD "2swap", 2SWAP /* ( d1 d2 -- d2 d1 ) swap top two cell pairs on the stack */
  bl dswap
  NEXT

dswap:
  ldm DSP!, {r0, r1, r2}
  subs DSP, #4
  str r0, [DSP]
  savetos
  subs DSP, #4
  str r2, [DSP]
  movs TOS, r1
  bx lr
END 2SWAP
