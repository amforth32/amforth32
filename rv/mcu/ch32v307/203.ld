/* SPDX-License-Identifier: GPL-3.0-only */
ENTRY( _start )

/* standard flash mode */
FLASH_ORIGIN = 0x00000000;

/* Allocate end of FLASH as PVFLASH */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;
FLASH_SIZE = 64K - PVFLASH_SIZE;
PVFLASH_ORIGIN = FLASH_ORIGIN + FLASH_SIZE;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
   /* Use end of code flash as PVFLASH */
   FLASH (rx)  : ORIGIN = FLASH_ORIGIN, LENGTH = FLASH_SIZE
   PVFLASH(rw) : ORIGIN = PVFLASH_ORIGIN, LENGTH = PVFLASH_SIZE
   RAM (xrw)   : ORIGIN = 0x20000000, LENGTH = 20K
}

INCLUDE amforth32.ld
