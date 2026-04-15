# System Clock Support
# RA4M1 Group: User Manual (32-bit): 8. Clock Generation Circuit
# Table 8.1 Clock sources:
# * Main clock oscillator (MOSC): 1-20MHz (2.4V < VCC <= 5.5V => 1 - 20 MHz)
# * Sub-clock oscillator (SOSC): 32768Hz
# * High-speed on-chip oscillator (HOCO): 24/32/48/64 MHz (option setting OFS1)
# * Middle-speed on-chip oscillator (MOCO): 8 MHz
# * Low-speed on-chip oscillator (LOCO): 32768 Hz
# * PLL circuit: MOSC -> 4-12.5MHz (PLLCR/PLLCCR2)
#
# NB: MOSC and SOSC are not available on UNO R4 board
# UNOR4 Booloader setup:
# * HOCO 48MHz used as system clock source (option memory)
# * ICLK, PCLKA/C/D = 48MHz
# * PCLKB, FCLK = 24 MHz

# Option Setting Memory Registers (6. Option Setting Memory)
.equ RA4_OFS0, 0x00000400 @ Option Function Select Register 0 (32-bit) I/WDT
.equ RA4_OFS1, 0x00000404 @ Option Function Select Register 1 (32-bit) HOCO & voltage detection
# [08]    HOCOEN = HOCO Oscillation Enable ;  UNOR4 = 1 => enabled
# [14:12] HOCOFRQ = 24MHz(0), 32MHz(2), 48Mhz(4), 64Mhz(5) ; UNOR4 = 4 => 48MHz

.equ RA4_SCKDIVCR , 0x4001E020    @ System Clock Division Control Register (32-bit)
# for each clock below n = 0..6 => 1/2^n, i.e 1/1 ... 1/64
# reset => 4 i.e. 1/16 division
# [30:28] FCLK (Flash interface clock) UNOR4 = 1
# [26:24] ICLK (CPU, DTC, DMAC, Flash, SRAM) UNOR4 = 0
# [14:12] PCLKA (high speed: SPI, SCI, SCE5, CRC, GPT bus clock) UNOR4 = 0
# [10:08] PCLKB (DAC12, IIC, SSIE, DOC, CAC, CAN, AGT, POEG, CTSU, ELC, I/O Ports,
#                    RTC, WDT, IWDT, ADC14, KINT, USBFS, ACMPLP and SLCDC) UNOR4 = 1
# [06:04] PCLKC (ADC14 conversion clock) UNOR4 = 0
# [02:00] PCLKD (GPT count clock) UNOR4 = 0

.equ RA4_SCKSCR, 0x4001E026   @ System Clock Source Control Register (8-bit)
# [02:00] CKSEL = HOCO(0), MOCO(1), LOCO(2), MOSC(3), SOSC(4), PLL(5) ; UNOR4 = 0 => HOCO
# reset => MOCO

