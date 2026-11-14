/*  ARMv7M System Memory Region 0xE0000000-0xFFFFFFFF
    Ref: ARMv7-M Architecture Reference Manual */

/* B3.2.2 System control and ID registers (System Control Space SCS) */
.equ ARM_CPUID, 0xE000ED00 /* CPUID Base Register */
.equ ARM_ICSR, 0xE000ED04 /* Interrupt Control Register */
.equ ARM_VTOR, 0xE000ED08 /* Vector Table Offset Register */
.equ ARM_AIRCR, 0xE000ED0C /* Application Interrupt and Reset Control Register */
.equ ARM_SCR, 0xE000ED10 /* System Control Register */
.equ ARM_CCR, 0xE000ED14 /* Configuration and Control Register */
.equ ARM_SHPR1, 0xE000ED18 /* System Handler Priority Register */
.equ ARM_SHPR2, 0xE000ED1C /* System Handler Priority Register */
.equ ARM_SHPR3, 0xE000ED20 /* System Handler Priority Register */
.equ ARM_SHCSR, 0xE000ED24 /* System Handler Control and State Register */
.equ ARM_CFSR, 0xE000ED28 /* Configurable Fault Status Register */
.equ ARM_HFSR, 0xE000ED2C /* HardFault Status Register */
.equ ARM_DFSR, 0xE000ED30 /* Debug Fault Status Register */
.equ ARM_MMFAR, 0xE000ED34 /* MemManage Fault Address Register */
.equ ARM_BFAR, 0xE000ED38 /* BusFault Address Register */
.equ ARM_AFSR, 0xE000ED3C /* Auxiliary Fault Status Register */

.equ ARM_ICTR, 0xE000E004 /* Interrupt Controller Type Register */
.equ ARM_ACTLR, 0xE000E008 /* Auxiliary Control Register */
.equ ARM_STIR, 0xE000EF00 /* Software Triggered Interrupt Register */


/* B3.4 Nested Vectored Interrupt Controller, NVIC
   ICTR.INTLINESNUM[5:0] (INTLINESNUM+1)*32 = number of implemented interrupts (max 496)  */
.equ ARM_NVIC_ISER, 0xE000E100 /* Interrupt Set-Enable Registers (0-15), bit per interrupt */
.equ ARM_NVIC_ICER, 0xE000E180 /* Interrupt Clear-Enable Registers (0-15), bit per interrupt */
.equ ARM_NVIC_ISPR, 0xE000E200 /* Interrupt Set-Pending Registers (0-15), bit per interrupt */
.equ ARM_NVIC_ICPR, 0xE000E280 /* Interrupt Clear-Pending Registers (0-15), bit per interrupt */
.equ ARM_NVIC_IABR, 0xE000E300 /* Interrupt Active Bit Registers (0-15), bit per interrupt */
.equ ARM_NVIC_IPR, 0xE000E400 /* Interrupt Priority Registers (0-123), byte per interrupt */

