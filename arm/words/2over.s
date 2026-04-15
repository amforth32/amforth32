CODEWORD "2over", 2OVER /* ( d1 d2 -- d1 d2 d1 ) copy 2nd cell pair to the top of the stack */
  ldr r0, [DSP, #8]
  savetos
  sub DSP, #4
  str r0, [DSP]
  ldr TOS, [DSP, #12]  
  NEXT
END 2OVER
