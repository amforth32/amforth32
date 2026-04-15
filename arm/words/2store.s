CODEWORD  "2!", 2STORE /* ( d addr -- ) store two cells at addr */
  ands r0, TOS, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */
  ldmia DSP!, {r1, r2}
  str r1, [TOS]
  str r2, [TOS, #4]
  loadtos
  NEXT
END 2STORE
