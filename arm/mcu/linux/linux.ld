ENTRY (_start)

/* It's all RAM we can allocate as much as we want */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY {
    FLASH (rwx) : ORIGIN = 0x00010000, LENGTH = 256K - PVFLASH_SIZE
    PVFLASH(WRX) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
    RAM (rwx)  : ORIGIN = 0x10000000, LENGTH = 1M
}

INCLUDE amforth32.ld
