
CODEWORD  "depth", DEPTH /* ( -- n ) n is current dept of the data stack */
  add r1, UP, #USER_SP0
  sub r1, DSP 
  savetos
  asrs TOS, r1, #2 
  NEXT
END DEPTH

CODEWORD  "rdepth", RDEPTH /* ( -- n ) n is current dept of the return stack */
  savetos
  mov TOS, sp
  add r1, UP, #USER_RP0
  sub r1, TOS 
  asrs TOS, r1, #2 
  NEXT
END RDEPTH

CODEWORD  "rdrop", RDROP /* (R: x -- ) drop top of the return stack */
  add sp, #4
  NEXT
END RDROP
