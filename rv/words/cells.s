# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "cells", CELLS /* ( n1 -- n2 ) n2 = n1 * cellsize */ 
  slli s3, s3, 2
  NEXT
END CELLS
