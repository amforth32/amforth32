# SPDX-License-Identifier: GPL-3.0-only
# reset
# p26 manual & p95 of manual

.equ R32_PFIC_CFGR , 0xE000E048 # PFIC interrupt configuration register
.equ KEY3          , 0xBEEF0000 # 
CODEWORD "reset" , RESET # ( -- ) SYSTEM: reset the mcu 

         li  t0, R32_PFIC_CFGR
         li  t1, KEY3
         ori t1, t1, (1<<7)
         sw  t1, 0(t0)
         NEXT
END RESET

# ----------------------------------------------------------------------
# KEEP DO NOT DELETE
# This does not work as hoped if the operator prompt is on USBHS, it
# just resets and gives you back the prompt. Need a USBFS operator to take
# this idea further.

# CODEWORD "bootloader" , BOOTLOADER /* ( -- ) prime for ch32v bootloader and reset */
#     # Load Peripheral Base Addresses
#     li  t2, 0x40022000      # t2 = FLASH Base Address
#     li  t3, 0x40021000      # t3 = RCC Base Address
#     li  t4, 0xE000E000      # t4 = PFIC Base Address

#     # 1. Unlock Boot Registers
#     li  t0, 0x45670123
#     sw  t0, 0x24(t2)        # Store KEY1 to FLASH->BOOT_MODEKEYR (Offset 0x24)
#     li  t0, 0xCDEF89AB
#     sw  t0, 0x24(t2)        # Store KEY2 to FLASH->BOOT_MODEKEYR (Offset 0x24)

#     # 2. Set Boot Mode Bit
#     lw  t1, 0x0C(t2)        # Read FLASH->STATR (Offset 0x0C)
#     li  t0, 0x4000
#     or  t1, t1, t0
#     sw  t1, 0x0C(t2)        # Write FLASH->STATR with MODE bit set

#     # 3. Clear Reset Flags
#     lw  t1, 0x24(t3)        # Read RCC->RSTSCKR (Offset 0x24)
#     li  t0, 0x1000000
#     or  t1, t1, t0
#     sw  t1, 0x24(t3)        # Write RCC->RSTSCKR

#     # 4. Fire System Reset 
#     li  t0, 0xBEEF0080
#     sw  t0, 0x48(t4)        # Store Reset Command to PFIC->CFGR (Offset 0x48)

#     NEXT
# END BOOTLOADER
# ----------------------------------------------------------------------
