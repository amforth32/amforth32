/* SPDX-License-Identifier: GPL-3.0-only */
ENTRY( _start )

/* standard flash mode */
FLASH_ORIGIN = 0x00000000;

/* Allocate end of FLASH as PVFLASH */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K; 
FLASH_SIZE = 256K - PVFLASH_SIZE;
PVFLASH_ORIGIN = FLASH_ORIGIN + FLASH_SIZE;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
/* CH32V30x_D8C - CH32V305RB-CH32V305FB
   CH32V30x_D8 - CH32V303CB-CH32V303RB
*/
/*
	FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 128K
	RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 32K
*/
    
/* CH32V30x_D8C - CH32V307VC-CH32V307WC-CH32V307RC
   CH32V30x_D8 - CH32V303VC-CH32V303RC
   FLASH + RAM supports the following configuration
   FLASH-192K + RAM-128K
   FLASH-224K + RAM-96K
   FLASH-256K + RAM-64K  
   FLASH-288K + RAM-32K  
*/
   /* Use end of code flash as PVFLASH */
   FLASH (rx)  : ORIGIN = FLASH_ORIGIN, LENGTH = FLASH_SIZE
   PVFLASH(rw) : ORIGIN = PVFLASH_ORIGIN, LENGTH = PVFLASH_SIZE
   RAM (xrw)   : ORIGIN = 0x20000000, LENGTH = 64K
}

INCLUDE amforth32.ld
