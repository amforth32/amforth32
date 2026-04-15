# SPDX-License-Identifier: GPL-3.0-only

VALUE     "dp.cache"    , DP_CACHE , 0
END DP_CACHE
NVARIABLE "flash.cache" , FLASH_CACHE , flash_cell / cellsize
END FLASH_CACHE
NVARIABLE "flash.shadow" , FLASH_SHADOW , flash_cell / cellsize
END FLASH_SHADOW

#======================================================================

CODEWORD "(flash.erase)" , DOFLASH_ERASE /* ( fa -- ) erase page containing fa */ 
    ldr r3, =__flash_erase__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
	NEXT
END DOFLASH_ERASE

CODEWORD "(flash.write)" , DOFLASH_WRITE /* ( fa -- ) write flash.cache to flash at fa */
    ldr r3, =__flash_write__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
	NEXT 
END DOFLASH_WRITE

COLON "flash.write" , FLASH_WRITE /* ( fa -- ) write flash.cache to flash at fa - flash.cell */
    .word XT_FLASH_CELL
    .word XT_MINUS
    .word XT_DOFLASH_WRITE
    .word XT_EXIT
END FLASH_WRITE

CODEALIAS "~flash.erase", TILDEFLASH_ERASE, DOFLASH_ERASE /* ( addr -- ) erase FLASH page at addr */
END TILDEFLASH_ERASE

#======================================================================
# NFF defer targets ( the words that do the work ) 

COLON "callot" , CALLOT
     .word XT_DP_CACHE
     .word XT_PLUS
     .word XT_DOTO
     .word XT_DP_CACHE
     .word XT_EXIT
END CALLOT

COLON "~!i", TILDESTORE_I /* ( x addr -- ) write x at addr in flash */
	/* don't allow writing below dp0.flash */
	.word XT_DUP
	.word XT_DP0_FLASH
	.word XT_LESS
	.word XT_DOCONDBRANCH, 1f /* # if */
	.word XT_DOLITERAL, EFWADDR, XT_THROW
1:	/* # then */
	.word XT_FLASH_CACHE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_TO_R
	.word XT_FLASH_CACHE
	.word XT_STORE
	.word XT_DOLITERAL
    .word XT_NOP
	.word XT_FLASH_CACHE
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_R_FROM
	.word XT_FLASH_CELL
	.word XT_PLUS
	.word XT_FLASH_WRITE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CACHE
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_EXIT
END TILDESTORE_I

COLON "~c!i", TILDECSTORE_I
    .word XT_DOLITERAL
    .word EUNSUP
    .word XT_THROW
END TILDECSTORE_I

COLON "ra!i", RASTORE_I /* ( x addr -- ) write x at addr in flash */
	/* don't allow writing below dp0.flash */
	.word XT_DUP
	.word XT_DP0_FLASH
	.word XT_LESS
	.word XT_DOCONDBRANCH, 1f /* # if */
	.word XT_DOLITERAL, EFWADDR, XT_THROW
1:	/* # then */
	.word XT_FLASH_CACHE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_TO_R
    .word XT_ZERO
	.word XT_FLASH_CACHE
	.word XT_STORE
	.word XT_FLASH_CACHE
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_R_FROM
	.word XT_FLASH_CELL
	.word XT_PLUS
	.word XT_FLASH_WRITE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CACHE
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_EXIT
END RASTORE_I


#======================================================================
# PVFLASH primitives

CODEALIAS "~pvflash.erase", TILDEPVFLASH_ERASE, DOFLASH_ERASE /* ( addr -- ) erase PVFLASH page at addr */
END TILDEPVFLASH_ERASE

NONAME "~2!pvf", TILDE2STORE_PVF /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
	/* don't allow writing below pvflash.start */
	.word XT_DUP, XT_PVFLASH_START, XT_LESS, XT_DOCONDBRANCH, 1f /* # if */
		.word XT_DOLITERAL, EFWADDR, XT_THROW
1:	/* then */
	/* back up flash.cache */
	.word XT_FLASH_CACHE, XT_FLASH_SHADOW, XT_FLASH_CELL, XT_MOVE
	.word XT_MROT /* ( addr x1 x2 ) */
	.word XT_FLASH_CACHE, XT_STORE
	.word XT_FLASH_CACHE, XT_CELLPLUS, XT_STORE
	.word XT_DOFLASH_WRITE
	/* restore flash cache */
	.word XT_FLASH_SHADOW, XT_FLASH_CACHE, XT_FLASH_CELL, XT_MOVE
	.word XT_EXIT
END TILDE2STORE_PVF

# ----------------------------------------------------------------------
# NFF3

COLON "~c,", TILDECCOMMA 
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_CSTORE
    .word XT_ONE
    .word XT_DALLOT
	.word XT_EXIT
END TILDECCOMMA

COLON "~,", TILDECOMMA
    .word XT_DALIGN
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT
END TILDECOMMA

COLON "~dallot", TILDEDALLOT /* ( u -- allocate u bytes in the dictionary ) */
	/* Are we crossing over to the next flash page? dp mod flash.page == 0 ? */
	.word XT_DP, XT_FLASH_PAGE, XT_MOD, XT_ZEROEQUAL
	.word XT_DOCONDBRANCH, 1f /* if */
		/* Is the flash.cache empty? */
		.word XT_DP_CACHE, XT_ZEROEQUAL
		.word XT_DOCONDBRANCH, 2f /* if */
			/* if so, erase the flash page at DP */
			.word XT_DP, XT_DOFLASH_ERASE
			.word XT_DOBRANCH, 1f
2:		/* else */
			/* this should not happen, throw */
			.word XT_DROP
			.word XT_DOLITERAL, EFCACHE, XT_THROW
1: /* then */
	.word XT_TO_R, XT_R_FETCH /* copy u to R stack */
	/* Is u + dp.cache < flash.cell ? */
	.word XT_DP_CACHE, XT_PLUS, XT_FLASH_CELL, XT_LESS
	.word XT_DOCONDBRANCH, 2f /* if */
		/* allocate u bytes in flash.cache */
		.word XT_R_FETCH, XT_CALLOT
		/* increment DP by u */
		.word XT_R_FROM, XT_DP, XT_PLUS, XT_DOTO, XT_DP
		.word XT_FINISH
2:	/* else */
		/* is u + dp.cache == flash.cell ? */
		.word XT_R_FETCH, XT_DP_CACHE, XT_PLUS, XT_FLASH_CELL, XT_EQUAL
		.word XT_DOCONDBRANCH, 3f /* if */
			/* zero out dp.cache */
			.word XT_ZERO, XT_DOTO, XT_DP_CACHE
			.word XT_R_FROM, XT_DP, XT_PLUS, XT_DUP
			/* ( dp+u dp+u ) */
			.word XT_DOTO, XT_DP /* update dp */
			.word XT_FLASH_WRITE /* flush the cache */
			.word XT_FINISH
 3: 	/* else */
			/* u + dp.cache > flash.cell ? throw */
			.word XT_R_FROM
			.word XT_DROP
			.word XT_DOLITERAL, EFCELLA, XT_THROW
END TILDEDALLOT
