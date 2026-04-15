# SPDX-License-Identifier: GPL-3.0-only
COLON "2@" , 2FETCH /* ( a -- x1 x2 ) x1 = [a+cellsize], x2 = [a]  */
      .word XT_DUP
      .word XT_CELLPLUS
      .word XT_FETCH
      .word XT_SWAP
      .word XT_FETCH
      .word XT_EXIT
END 2FETCH
      
