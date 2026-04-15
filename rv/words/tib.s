# SPDX-License-Identifier: GPL-3.0-only

# -----------------------------------------------------------------------------
  CODEWORD "tib", TIB /* ( -- addr ) terminal input buffer address */
# -----------------------------------------------------------------------------
  savetos
  la s3, RAM_lower_refill_buf
  NEXT
END TIB

VARIABLE "#tib", NUMBERTIB /* ( -- addr ) [addr] is number of characters stored in TIB */
END NUMBERTIB
