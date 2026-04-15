CODEWORD "2>r", 2TO_R /* ( d -- )(R: -- d ) move top two cells from data stack to return stack */
  popnos r0
  push {r0}
  push {TOS}
  loadtos
  NEXT
END 2TO_R
