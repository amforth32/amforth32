# SPDX-License-Identifier: GPL-3.0-only
COLON "2!" , 2STORE /* ( x1 x2 a -- ) [a] = x2, [a+cellsize] = x1 */
      .word XT_SWAP
      .word XT_OVER
      .word XT_STORE
      .word XT_CELLPLUS
      .word XT_STORE
      .word XT_EXIT
END 2STORE
