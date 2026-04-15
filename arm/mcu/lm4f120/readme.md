# AmForth for TI Stellaris LM4F120 LaunchPad

AmForth is published under the GNU Public License v3 (GPL).

# MCU

## LM4F120H5QR 32-bit ARM Cortex M4F (renamed to Tiva TM4C1233H6PM)
Stellaris LM4F120 LaunchPad Evaluation Board
* 256 kB flash memory
* 32 kB SRAM: $20000000 .. $20008000
* 80 MHz

## QEMU -M lm3s6965evb (can't write to flash!)
Luminary Micro Stellaris LM3S6965EVB emulation includes the following devices:
* Cortex-M3 CPU core.
* 256k Flash and 64k SRAM.
* Timers, UARTs, ADC, I2C and SSI interfaces.
* OSRAM Pictiva 128x64 OLED with SSD0323 controller connected via SSI.

## QEMU -M lm3s811evb (can't write to flash!)
Luminary Micro Stellaris LM3S811EVB emulation includes the following devices:
* Cortex-M3 CPU core.
* 64k Flash and 8k SRAM.
* Timers, UARTs, ADC and I2C interface.
* OSRAM Pictiva 96x16 OLED with SSD0303 controller on I2C bus.

# Peripherals

## GPIO
* PF4 SW1
* PF0 SW2
* PF1 LED (red)
* PF2 LED (blue)
* PF3 LED (green)

# References

* https://www.qemu.org/docs/master/system/arm/stellaris.htm
* https://docs.platformio.org/en/latest/boards/titiva/lplm4f120h5qr.html
* LM4F120 User Manual https://www.ti.com/lit/ug/spmu289c/spmu289c.pdf?ts=1769119127997
* https://www.ti.com/product/LM3S6965
* https://www.ti.com/product/LM3S811
