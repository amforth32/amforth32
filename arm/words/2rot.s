# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2rot", 2ROT /* (d1 d2 d3 -- d2 d3 d1) rotate top 3 cell pairs on stack left, 3rd pair becomes top pair */
  ldrd r0, r1, [DSP, #12] @ store d1
  ldrd r2, r3, [DSP, #4] @ move d2
  strd r2, r3, [DSP, #12] 
  ldr r2, [DSP]  @ move d3
  str r2, [DSP, #8]
  str TOS, [DSP, #4]
  str r1, [DSP] @ restore d1 at top
  mov TOS, r0
  NEXT
END 2ROT
