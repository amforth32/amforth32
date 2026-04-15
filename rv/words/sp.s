# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "sp@", SP_FETCH /* ( -- addr ) addr is current data stack pointer */
# -----------------------------------------------------------------------------
  savetos
  mv s3, s4
  NEXT
END SP_FETCH

# -----------------------------------------------------------------------------
  CODEWORD "sp!", SP_STORE /* ( addr -- ) set data stack pointer to addr */
# -----------------------------------------------------------------------------
  mv s4, s3
  loadtos
  NEXT
END SP_STORE

USER "sp", SP, USER_SP /* ( -- addr ) storage address of data stack pointer */
END SP

USER "sp0", SP0, USER_SP0 /* ( -- addr ) storage address of initial data stack pointer */
END SP0
