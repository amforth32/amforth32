# SPDX-License-Identifier: GPL-3.0-only

# -----------------------------------------------------------------------------
  CODEWORD "tib", TIB /* ( -- addr ) terminal input buffer address */
# -----------------------------------------------------------------------------
  savetos
  addi s3, s6, USER_TIB
  NEXT
END TIB

VARIABLE "#tib", NUMBERTIB /* ( -- addr ) [addr] is number of characters stored in TIB */
END NUMBERTIB
