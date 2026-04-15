
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* Allocate end of FLASH as PVFLASH */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
   /* Use end of code flash as PVFLASH */
   FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 256K - PVFLASH_SIZE
   PVFLASH(RW) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
   RAM(WAIL)   : ORIGIN = 0x20000000, LENGTH = 32K
}

INCLUDE amforth32.ld