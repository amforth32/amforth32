/* SPDX-License-Identifier: GPL-3.0-only */
OUTPUT_ARCH( "riscv" )
ENTRY( _start )

/* RAM emulated PVFLASH */
PVFLASH_PAGE = 1K;
PVFLASH_CELL = 4;
PVFLASH_ERASED = 0x00000000;
PVFLASH_SIZE = 8K;
RAM_ORIGIN = 0x80040000;
RAM_SIZE = 256K - PVFLASH_SIZE;
PVFLASH_ORIGIN = RAM_ORIGIN + RAM_SIZE;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
#   FLASH (RWX)   : ORIGIN = 0x20010000, LENGTH = 256K
   FLASH (RWX)   : ORIGIN = 0x80000000, LENGTH = 256K
   RAM   (WAIXL) : ORIGIN = RAM_ORIGIN, LENGTH = RAM_SIZE
   /* Cannot write into emulated flash so allocate the end of RAM as faux PVFLASH */
   PVFLASH(WRX) : ORIGIN = PVFLASH_ORIGIN, LENGTH = PVFLASH_SIZE
}                                

INCLUDE amforth32.ld
