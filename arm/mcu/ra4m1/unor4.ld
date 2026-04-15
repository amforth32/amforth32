
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* https://github.com/Arduino/ArduinoCore-renesas/blob/main/variants/UNOWIFIR4/memory_regions.ld */

RAM_START = 0x20000000;
RAM_LENGTH = 0x8000;
FLASH_START = 0x00000000;
FLASH_LENGTH = 0x40000;
DATA_FLASH_START = 0x40100000;
DATA_FLASH_LENGTH = 0x2000;
FLASH_IMAGE_START = 0x4000;
VECTOR_TABLE_LENGTH = 0x100;
BSP_CFG_STACK_MAIN_BYTES = 0x400;

PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
  /* Use end of code flash as PVFLASH */
  FLASH (rx)      : ORIGIN = FLASH_IMAGE_START, LENGTH = FLASH_LENGTH - FLASH_IMAGE_START - PVFLASH_SIZE
  PVFLASH (rw)    : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
  RAM (rwx)       : ORIGIN = RAM_START, LENGTH = RAM_LENGTH
}

/* Dedicate the entire data flash to pvalues */
/* 
PVFLASH_PAGE = 1K;
PVFLASH_CELL = 1;
PVFLASH_SIZE = DATA_FLASH_LENGTH;
PVFLASH_ERASED = flash_erased;

MEMORY
{
  FLASH (rx)      : ORIGIN = FLASH_IMAGE_START, LENGTH = FLASH_LENGTH - FLASH_IMAGE_START
  RAM (rwx)       : ORIGIN = RAM_START, LENGTH = RAM_LENGTH
  PVFLASH (rx)    : ORIGIN = DATA_FLASH_START, LENGTH = DATA_FLASH_LENGTH
}
*/

INCLUDE amforth32.ld
