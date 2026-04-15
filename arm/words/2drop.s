CODEWORD "2drop", 2DROP /* ( d -- ) drop top cell pair from the stack */
  add DSP, #4
  loadtos
  NEXT
END 2DROP
