# SPDX-License-Identifier: GPL-3.0-only
CODEWORD ">r", TO_R /* ( x -- )(R: -- x) move TOS to return stack */ 
  push s3
  j PFA_DROP
END TO_R
