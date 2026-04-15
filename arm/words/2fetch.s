CODEWORD  "2@", 2FETCH /* ( addr - d ) fetch two cells at addr */
  ands r0, TOS, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */
  subs DSP, #4
  ldr r0, [TOS, #4]
  str r0, [DSP]
  ldr TOS, [TOS]
  NEXT
END 2FETCH
