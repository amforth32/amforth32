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

#======================================================================
# transpiling nram.f on 2026/05/13 10:49:15
# : nram, \# ( x n -- ) allocate n cells in ram, store x in each , store starting RAM address in dictionary
#     memmode if
#         dup >r 0 ?do dup vp i cells + ! loop drop
#         vp , r> cells vallot
#     else
#         dp cell+ , 0 ?do dup , loop drop
#     then
# ;
# 
# 

# ----------------------------------------------------------------------
COLON "nram,", NRAMCOMMA /* ( x n -- ) allocate n cells in ram, store x in each , store starting RAM address in dictionary  */
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,NRAMCOMMA_0001 /* if */
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,NRAMCOMMA_0002 /* ?do */
	.word XT_DODO
NRAMCOMMA_0003: /* do */
	.word XT_DUP
	.word XT_VP
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLOOP,NRAMCOMMA_0003 /* loop */
NRAMCOMMA_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_VP
	.word XT_COMMA
	.word XT_R_FROM
	.word XT_CELLS
	.word XT_VALLOT
	.word XT_DOBRANCH,NRAMCOMMA_0004
NRAMCOMMA_0001: /* else */
	.word XT_DP
	.word XT_CELLPLUS
	.word XT_COMMA
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,NRAMCOMMA_0005 /* ?do */
	.word XT_DODO
NRAMCOMMA_0006: /* do */
	.word XT_DUP
	.word XT_COMMA
	.word XT_DOLOOP,NRAMCOMMA_0006 /* loop */
NRAMCOMMA_0005: /* (for ?do IF required) */
	.word XT_DROP
NRAMCOMMA_0004: /* then */
	.word XT_EXIT
END NRAMCOMMA
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
