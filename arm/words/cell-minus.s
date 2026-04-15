CODEWORD "cell-", CELLMINUS /* ( n1 -- n2 ) n2 = n1 - cellsize */
  sub TOS, #cellsize
  NEXT
END CELLMINUS
