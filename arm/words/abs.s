CODEWORD "abs", ABS /* ( n1 -- n2 ) n2 = abs(n1) */
  cmp TOS, #0
  it lt
  neglt TOS, TOS
  NEXT
END ABS
