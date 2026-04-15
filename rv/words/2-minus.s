# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2-", 2MINUS /* ( n1 -- n2 ) n2 = n1 - 2 */
  addi s3, s3, -2
  NEXT
END 2MINUS
