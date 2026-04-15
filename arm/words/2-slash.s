CODEWORD "2/", 2SLASH /* ( n1 -- n2 ) n2 = n1 / 2 */
  asr TOS, TOS, #1
  NEXT
END 2SLASH
