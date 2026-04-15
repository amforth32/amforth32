
@ -----------------------------------------------------------------------------
  CODEWORD "rot", ROT /* (x1 x2 x3 -- x2 x3 x1) rotate top 3 cells on stack left, 3OS becomes TOS */
@ -----------------------------------------------------------------------------
  ldm DSP!, {r0, r1}
  subs DSP, #8
  str r0, [DSP, #4]
  str TOS, [DSP]
  movs TOS, r1
  NEXT
END ROT
