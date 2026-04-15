CODEWORD  "invert", INVERT /* ( x1 -- x2 ) x2 = ~x1 (bitwise) */
  mvns TOS, TOS
  NEXT
END INVERT
