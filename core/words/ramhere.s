# SPDX-License-Identifier: GPL-3.0-only

CONSTANT "vp0"    , VP0      , vp0 /* start of the RAM pool */
END VP0
CONSTANT "vp.max" , VPDOTMAX , vp.max /* end of the RAM pool */
END VPDOTMAX
PVALUE    "vp"     , VP       , vp0 /* RAM pool pointer */
END VP

NONAME "ram,", RAMCOMMA /* ( x -- ) allocate 1 cell in RAM, store x in it, compile the address into the dictionary */
    .word XT_MEMMODE, XT_DOCONDBRANCH, 1f
        /* we are in flash mode, allocate space in RAM pool */
        .word XT_VP, XT_SWAP, XT_OVER, XT_STORE /* store x at VP */
        .word XT_CELL, XT_VALLOT /* allocate the space for it (updates VP!) */
        .word XT_COMMA /* compile original VP into the dictionary */
        .word XT_FINISH
    1:  /* else we're in RAM mode, allocate space in the dictionary space
          this means allocate the RAM slot right after the address slot */
        .word XT_DP, XT_CELLPLUS, XT_DUP, XT_COMMA /* store the RAM slot address in the dictionary */
        .word XT_CELL, XT_DALLOT /* allocate space for the extra slot */
        .word XT_STORE /* store x in the allocated space */
        .word XT_EXIT
END RAMCOMMA
