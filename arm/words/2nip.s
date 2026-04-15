CODEWORD "2nip", 2NIP /* ( d2 d1 -- d1 ) remove 2nd cell pair from the stack */
  ldmia DSP!, {r0, r1, r2}
  sub DSP, #4
  str r0, [DSP]
  NEXT
END 2NIP
