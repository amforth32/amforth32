# From RA4M1 Group: User Manual (32-bit): 28 Serial Communications Interface (SCI)
#   * only SCI0 and SCI1 support FIFO

.equ RA4_MSTPCRB, 0x40047000 @ Module Stop Control Register B
.equ RA4_MSTPCRB22, 1 << 22  @ [22] SCI9 Module Stop (reset = 1)
.equ RA4_MSTPCRB29, 1 << 29  @ [29] SCI2 Module Stop (reset = 1)
.equ RA4_MSTPCRB30, 1 << 30  @ [30] SCI1 Module Stop (reset = 1)
.equ RA4_MSTPCRB31, 1 << 31  @ [31] SCI0 Module Stop (reset = 1)

# with FIFO
.equ SCI0_BASE, 0x40070000   @ base address of the SCI0 registers
.equ SCI1_BASE, 0x40070020   @ base address of the SCI1 registers
# no FIFO
.equ SCI2_BASE, 0x40070040   @ base address of the SCI2 registers
.equ SCI9_BASE, 0x40070120   @ base address of the SCI9 registers

// SCI Register Offsets
.equ SCI_SMR,  0x00   @ Serial Mode Register
.equ SCI_BRR,  0x01   @ Bit Rate Register 
.equ SCI_SCR,  0x02   @ Serial Control Register
.equ SCI_TDR,  0x03   @ Transmit Data Register 
.equ SCI_SSR,  0x04   @ Serial Status Register
.equ SCI_RDR,  0x05   @ Receive Data Register 
.equ SCI_SCMR,  0x06  @ Smart Card Mode Register 
.equ SCI_SEMR,  0x07  @ Serial Extended Mode Register
.equ SCI_SNFR,  0x08  @ Noise Filter Setting Register
.equ SCI_SIMR1,  0x09 @ I2C Mode Register 1
.equ SCI_SIMR2,  0x0A @ I2C Mode Register 2
.equ SCI_SIMR3,  0x0B @ I2C Mode Register 3
.equ SCI_SISR,  0x0C  @ I2C Status Register 
.equ SCI_SPMR,  0x0D  @ SPI Mode Register 
.equ SCI_TDRHL,  0x0E @ Transmit 9-bit Data Register (16-bit)
.equ SCI_RDRHL,  0x10 @ Receive 9-bit Data Register (16-bit)
.equ SCI_MDDR,  0x12  @ Modulation Duty Register
.equ SCI_DCCR,  0x13  @ Data Compare Match Control Register
.equ SCI_CDR,  0x1A   @ Compare Match Data Register (16-bit)
.equ SCI_SPTR,  0x1C  @ Serial Port Register
.equ SCI_FCR,  0x14  @ FIFO Control Register (16-bit)
.equ SCI_FDR,  0x16  @ FIFO Data Count Register (16-bit)
.equ SCI_LSR,  0x18  @ Line Status Register (16-bit)

// Status register (SSR) bits
.equ SCI_SSR_TEND, 0x04 @ Transmit End 
.equ SCI_SSR_PER, 0x08 @ Parity Error
.equ SCI_SSR_FER, 0x10 @ Framing Error
.equ SCI_SSR_ORER, 0x20 @ Overrun Error
.equ SCI_SSR_RDRF, 0x40 @ Receive Data Full
.equ SCI_SSR_TDRE, 0x80 @ Transmit Data Empty
.equ SCI_SSR_RERR, SCI_SSR_PER | SCI_SSR_FER | SCI_SSR_ORER @ All RX Errors

.macro _sci_registers n
.if \n > 2 && \n != 9
.error "Invalid SCI number"
.endif
@ the \() is necessary to help as recognize the parameter reference
.equ SCI\n\()_SMR, SCI\n\()_BASE + 0x00   @ Serial Mode Register
.equ SCI\n\()_BRR, SCI\n\()_BASE + 0x01   @ Bit Rate Register 
.equ SCI\n\()_SCR, SCI\n\()_BASE + 0x02   @ Serial Control Register
.equ SCI\n\()_TDR, SCI\n\()_BASE + 0x03   @ Transmit Data Register 
.equ SCI\n\()_SSR, SCI\n\()_BASE + 0x04   @ Serial Status Register
.equ SCI\n\()_RDR, SCI\n\()_BASE + 0x05   @ Receive Data Register 
.equ SCI\n\()_SCMR, SCI\n\()_BASE + 0x06  @ Smart Card Mode Register 
.equ SCI\n\()_SEMR, SCI\n\()_BASE + 0x07  @ Serial Extended Mode Register
.equ SCI\n\()_SNFR, SCI\n\()_BASE + 0x08  @ Noise Filter Setting Register
.equ SCI\n\()_SIMR1, SCI\n\()_BASE + 0x09 @ I2C Mode Register 1
.equ SCI\n\()_SIMR2, SCI\n\()_BASE + 0x0A @ I2C Mode Register 2
.equ SCI\n\()_SIMR3, SCI\n\()_BASE + 0x0B @ I2C Mode Register 3
.equ SCI\n\()_SISR, SCI\n\()_BASE + 0x0C  @ I2C Status Register 
.equ SCI\n\()_SPMR, SCI\n\()_BASE + 0x0D  @ SPI Mode Register 
.equ SCI\n\()_TDRHL, SCI\n\()_BASE + 0x0E @ Transmit 9-bit Data Register (16-bit)
.equ SCI\n\()_RDRHL, SCI\n\()_BASE + 0x10 @ Receive 9-bit Data Register (16-bit)
.equ SCI\n\()_MDDR, SCI\n\()_BASE + 0x12  @ Modulation Duty Register
.equ SCI\n\()_DCCR, SCI\n\()_BASE + 0x13  @ Data Compare Match Control Register
.equ SCI\n\()_CDR, SCI\n\()_BASE + 0x1A   @ Compare Match Data Register (16-bit)
.equ SCI\n\()_SPTR, SCI\n\()_BASE + 0x1C  @ Serial Port Register
.if \n < 2
.equ SCI\n\()_FCR, SCI\n\()_BASE + 0x14  @ FIFO Control Register (16-bit)
.equ SCI\n\()_FDR, SCI\n\()_BASE + 0x16  @ FIFO Data Count Register (16-bit)
.equ SCI\n\()_LSR, SCI\n\()_BASE + 0x18  @ Line Status Register (16-bit)
.endif
.endm

_sci_registers 0 @ define the SCI0 registers
_sci_registers 1 @ define the SCI1 registers
_sci_registers 2 @ define the SCI2 registers
_sci_registers 9 @ define the SCI9 registers
