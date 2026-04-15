CODEWORD "1-", 1MINUS /* ( n1 -- n2 ) n2 = n1 - 1 */
  sub TOS, #1
  NEXT
END 1MINUS
