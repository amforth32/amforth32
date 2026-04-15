# SPDX-License-Identifier: GPL-3.0-only
COLON "bounds", BOUNDS /* ( addr len -- addr+len addr ) convert a string to an address range */
  .word XT_OVER,XT_PLUS,XT_SWAP,XT_EXIT
END BOUNDS

