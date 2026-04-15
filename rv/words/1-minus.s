# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "1-", 1MINUS /* ( n1 -- n2 ) n2 = n1 - 1 */
  addi s3, s3, -1
  NEXT
END 1MINUS
