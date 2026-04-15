
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* RAM emulated PVFLASH */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

MEMORY
{
    FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 256K
    RAM(WAIL) : ORIGIN = 0x20000000, LENGTH = 64K - PVFLASH_SIZE
    /* Cannot write into emulated flash so allocate the end of RAM as faux PVFLASH */
    PVFLASH(WRX) : ORIGIN = ORIGIN(RAM) + LENGTH(RAM), LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld
