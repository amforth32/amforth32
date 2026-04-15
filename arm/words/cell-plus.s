CODEWORD "cell+", CELLPLUS /* ( n1 -- n2 ) n2 = n1 + cellsize */
  add TOS, #cellsize
  NEXT
END CELLPLUS
