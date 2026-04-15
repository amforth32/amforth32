# SPDX-License-Identifier: GPL-3.0-only
/*	Common aspects of flash support, relied on by the core.
	Expected to be supported by all MCUs.
*/

CONSTANT  "flash.page"  , FLASH_PAGE , flash_page /* size of the flash erase page (bytes) */
END FLASH_PAGE
CONSTANT  "flash.cell"  , FLASH_CELL , flash_cell /* size of the flash write cell (bytes) */
END FLASH_CELL
CONSTANT  "flash.erased"  , FLASH_ERASED , flash_erased /* value of an erased flash cell (4 bytes) */
END FLASH_ERASED
CONSTANT "flash.start" , FLASH_START  , flash.start /* start of the FLASH memory region */
END FLASH_MAX
CONSTANT "flash.low"    , FLASH_LOW   , flash.low /* start of the core dictionary in FLASH */
END FLASH_LOW
CONSTANT "flash.max"    , FLASH_MAX  , flash.max /* end of the FLASH memory region */
END FLASH_MAX

/* flash primitives */

DEFER "!i", STORE_I , XT_TILDESTORE_I /* ( x addr -- ) write x at addr in flash */
END STORE_I

DEFER "c!i" CSTORE_I , XT_TILDECSTORE_I /* ( c addr -- ) write c at addr in flash */
END CSTORE_I


DEFER "flash.erase", FLASH_ERASE, XT_TILDEFLASH_ERASE /* ( addr -- ) erase flash page at addr */
END FLASH_ERASE

.ifdef FLUSH_REQUIRED

NONAME "(flush)", DOFLUSH 
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH, 1f /* if */
    .word XT_DP_CACHE
#   .word XT_DUP , XT_HEXDOT , XT_CR 
    .word XT_DOCONDBRANCH, 1f /* if */
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_DP_CACHE
	.word XT_MINUS
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_FILL
	.word XT_R_FROM
	.word XT_DALLOT
1: /* then */
	.word XT_EXIT
END DOFLUSH

.endif

COLON "flush", FLUSH /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_DOFLUSH
.endif
    .word XT_EXIT
END FLUSH

NONAME "flash.flush", FLASHDOTFLUSH /* ( -- ) force flush (write) of flash.cache */
    .word XT_DALIGN
.ifdef FLUSH_REQUIRED
    .word XT_DOFLUSH 
.endif
    .word XT_EXIT
END FLASHDOTFLUSH

# ----------------------------------------------------------------------
# NFF3

NONAME "ram>flash", RAM2FLASH /* ( -- ) assign defer targets for flash mode (memmode=true) */
	.word XT_DOXLITERAL
	.word XT_TILDECCOMMA
	.word XT_DOXLITERAL
	.word XT_CCOMMA
	.word XT_DEFER_STORE
	.word XT_DOXLITERAL
	.word XT_TILDEDALLOT
	.word XT_DOXLITERAL
	.word XT_DALLOT
	.word XT_DEFER_STORE
	.word XT_DOXLITERAL
	.word XT_TILDECOMMA
	.word XT_DOXLITERAL
	.word XT_COMMA
	.word XT_DEFER_STORE
	STRING "targeting flash..."
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
END RAM2FLASH
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "flash>ram", FLASH2RAM /* ( -- ) assign defer targets for RAM mode (memmode=false) */
	.word XT_DOXLITERAL
	.word XT_CARETCCOMMA
	.word XT_DOXLITERAL
	.word XT_CCOMMA
	.word XT_DEFER_STORE
	.word XT_DOXLITERAL
	.word XT_CARETDALLOT
	.word XT_DOXLITERAL
	.word XT_DALLOT
	.word XT_DEFER_STORE
	.word XT_DOXLITERAL
	.word XT_CARETCOMMA
	.word XT_DOXLITERAL
	.word XT_COMMA
	.word XT_DEFER_STORE
	STRING "targeting ram..."
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
END FLASH2RAM
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
