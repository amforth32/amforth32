@ -----------------------------------------------------------------------------
  CODEWORD "tuck", TUCK /* ( x1 x2 -- x2 x1 x2 ) insert TOS below 2nd cell of the stack */ 
@ -----------------------------------------------------------------------------
tuck:
  popnos r0
  subs DSP, #8
  str TOS, [DSP, #4]
  str r0, [DSP]
  NEXT
END TUCK
