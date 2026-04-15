# SPDX-License-Identifier: GPL-3.0-only

COLON "vhere", VHERE /* ( -- addr ) return variable pool pointer VP */
  .word XT_VP
  .word XT_EXIT
END VHERE
