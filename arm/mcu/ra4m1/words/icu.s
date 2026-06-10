/*
    RA4M1 Group: User Manual: 13. Interrupt Controller Unit (ICU)
    * peripheral function interrupts: 174 sources
    * external pin interrupts: 15 sources IRQ0-12,14,15
    * NVIC: 32 sources
    * NMI, Oscillation stop, WDT, IWDT, Voltage Monitor 1/2, VBATT
    * SRAM parity/ECC, BUS slave/master error, Stack pointer Monitor
    * Low Power mode return
 */

.equ RA4_ICU_IELSR, 0x40006300 /* ICU Event Link Setting Register n (IELSRn) = IELSR + 4n */
/*
    13.2.6 ICU Event Link Setting Register n (IELSRn)
    * IELS[7:0] - ICU Event Link Selec R/W; 0 = disabled, otherwise see 13.3.2 Event Table
    * IR[16] - Interrupt Status Flag R/(W); write 0 to clear request
    * DTCE[24] - DTC Activation Enable R/W; activates DTC instead of NVIC
*/