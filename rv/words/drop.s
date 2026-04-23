# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "drop", DROP /* ( x -- ) drop TOS */
  loadtos
  NEXT
END DROP
