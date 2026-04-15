@ -----------------------------------------------------------------------------
  CODEWORD "!", STORE /* ( x addr -- ) [addr] = x; store word x at addr */
@ ----------------------------------------------------------------------------- 
  ands r0, TOS, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */ 
  ldm DSP!, {r0, r1} @ X is the new TOS after the store completes.
  str r0, [TOS]      @ Popping both saves a cycle.
  movs TOS, r1
  NEXT
END STORE
