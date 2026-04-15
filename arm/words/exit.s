CODEWORD "(exit)", EXIT /* (R: addr -- ) loads addr into IP; compiled by semicolon */
  pop {FIP}
  NEXT
END EXIT

CODEWORD "exit", FINISH /* (R: addr -- ) loads addr into IP; compiled by exit */
  pop {FIP}
  NEXT
END FINISH
