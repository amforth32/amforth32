/*

The mps2-an386 QEMU machine model emulates the Arm V2M-MPS2 prototyping board configured with the Arm Application Note AN386 FPGA image.

Hardware Specifications

• Arm Cortex-M4 with FPU (Floating Point Unit).
• Runs at a simulated default of 12 MHz.
• NVIC with 15 fixed exceptions and 45 IRQs.
• System Tick System Clock (SYSTICK).
• Peripherals / Components:
	• Cortex-M System Design Kit UART
	• ZBT SSRAM and local memory models (ZBTSRAM)
	• Ethernet controller modeled as LAN9118 (note: differs from physical LAN9220 in that checksum offloading is unsupported).

See https://www.qemu.org/docs/master/system/arm/mps2.html

*/

OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
   FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 256K - PVFLASH_SIZE
   PVFLASH(RW) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
   RAM(WAIL)   : ORIGIN = 0x20000000, LENGTH = 256K
}

INCLUDE amforth32.ld