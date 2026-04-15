# SPDX-License-Identifier: GPL-3.0-only

COLON "dhere", DHERE /* ( -- addr ) return dictionary pointer */
  .word XT_DP
  .word XT_EXIT
END DHERE
