
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* entry must be the ARM->Thumb wrapper */ 
ENTRY(_start) 

PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
   /* QEMU -M virt RAM starts at 0x40000000,
      we want to place both FLASH and RAM regions there */
   /* Use end of FLASH as PVFLASH */
   FLASH(RX)   : ORIGIN = 0x40000000, LENGTH = 256K - PVFLASH_SIZE
   PVFLASH(RW) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
   RAM(WAIL)   : ORIGIN = ORIGIN(FLASH) + 256K, LENGTH = 256K
}

INCLUDE amforth32.ld