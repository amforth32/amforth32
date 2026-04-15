@ -----------------------------------------------------------------------------
  CODEWORD "swap", SWAP /* ( x1 x2 -- x2 x1 ) swap top 2 cells on the stack */
@ -----------------------------------------------------------------------------
  ldr r1,  [DSP]  @ Load X from the stack, no SP change.
  str TOS, [DSP]  @ Replace it with TOS.
  movs TOS, r1    @ And vice versa.
  NEXT
END SWAP
