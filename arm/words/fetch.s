@ -----------------------------------------------------------------------------
  CODEWORD "@", FETCH /* (addr -- x) x = [addr]; load word at addr */
@ -----------------------------------------------------------------------------
  
  ands r0, TOS, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */ 
  ldr TOS, [TOS]
  NEXT
END FETCH
