
CODEWORD  "depth", DEPTH /* ( -- n ) n is current dept of the data stack */
  ldr r1, =RAM_upper_datastack 
  sub r1, DSP 
  savetos
  asrs TOS, r1, #2 
  NEXT
END DEPTH

CODEWORD  "rdepth", RDEPTH /* ( -- n ) n is current dept of the return stack */
  savetos
  mov TOS, sp
  ldr r1, =RAM_upper_returnstack
  sub r1, TOS 
  asrs TOS, r1, #2 
  NEXT
END RDEPTH

CODEWORD  "rdrop", RDROP /* (R: x -- ) drop top of the return stack */
  add sp, #4
  NEXT
END RDROP
