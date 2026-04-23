# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "dspcheck", DSPCHECK /* ( -- a n ) leave address and count for DUMP to view datastack memory */
  savetos
  la s3 , RAM_lower_runover
  andi s3 , s3, ~0b1111 
  savetos
  li s3 , 0x18
  NEXT
END DSPCHECK

