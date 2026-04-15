# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "rp@", RP_FETCH /* ( -- addr ) addr is current return stack pointer */
# -----------------------------------------------------------------------------
  savetos
  mv s3, s5
  NEXT
END RP_FETCH

# -----------------------------------------------------------------------------
  CODEWORD "rp!", RP_STORE /* ( addr -- ) set return stack pointer to addr */
# -----------------------------------------------------------------------------
  mv s5, s3
  loadtos
  NEXT
END RP_STORE

USER "rp", RP, USER_RP /* ( -- addr ) storage address for return stack pointer */
END RP
