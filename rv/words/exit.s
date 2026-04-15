# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "(exit)", EXIT /* (R: addr -- ) loads addr into IP; compiled by semicolon */
  pop s2   # IP
  NEXT
END EXIT

CODEWORD "exit", FINISH /* (R: addr -- ) loads addr into IP; compiled by exit */
  pop s2   # IP
  NEXT
END FINISH

