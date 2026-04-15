
# Implement serial connection to the ESP32 AT command server via SCI1,
# using non-FIFO async mode for now.
# TODO: try FIFO
# References:
# * RA4M1 Group: User Manual (32-bit): 28. Serial Communications Interface (SCI)

# SCI1 Pins 
.equ RA4_P501PFS, 0x40040940 + 4 * 1  @ TXD1
.equ RA4_P502PFS, 0x40040940 + 4 * 2  @ RXD1

# UART pins and registers SCI1
.equ AT_UART_BASE, SCI1_BASE
.equ AT_UART_TXD, RA4_P501PFS
.equ AT_UART_RXD, RA4_P502PFS
.equ AT_UART_STOP, RA4_MSTPCRB30

CODEWORD  "at-uart-init", AT_UART_INIT

@ Make sure SCI1 module is not stopped
  ldr r0, =RA4_MSTPCRB
  ldr r1, [r0]
  bic r1, r1, #AT_UART_STOP
  str r1, [r0]

@ Following 28.3.7. SCI Initialization in Asynchronous Mode
@ Omitting steps that should be set the prescribed way after reset
@ (see also Apendix 3 / Register descriptions)

  ldr     r0, =AT_UART_BASE

@ [ 0 ] SCR.TIE, RIE, TE, RE, and TEIE to 0
  mov r1, #0 @ Ensure SCI1 is disabled for configuration
  strb r1, [r0, #SCI_SCR]

@ [ 6 ] Write a value associated with the bit rate to BRR.
@ PCLKA 48MHz, B = 115200 bps, n = 0
@ N = PCLKA * 10^6 / (64 * 2^2n-1 * B) - 1 = 48000000 / (64 * 2^-1 * 115200) - 1 =
@   = 48000000 / (32 * 115200) - 1 ~ 12.02
  mov r1, #12   @ N = 12 computed above for 115200 bps
  strb r1, [r0, #SCI_BRR] @ Set the bit rate

@ [ 7 ] Write the value obtained by correcting a bit rate error in MDDR.
@ This step is not required if the BRME bit in SEMR is set to 0 or an external clock is used.
@ TODO: We may want to use this to reduce error rates

@ [ 8 ] Specify the I/O port to enable input and output functions as required for TXDn, RXDn, and SCKn pins.
  mov r1, #0  @ Set both pins to the SCI peripheral function
  movt r1, #0x0501  @ [24:28]PSEL = SCI(5) & [16]PMR = peripheral function(1)
  ldr r0, =AT_UART_TXD
  str r1, [r0]
  ldr r0, =AT_UART_RXD
  str r1, [r0]

@ [ 9 ] Set SCR.TE or SCR.RE to 1, also set SCR.TIE and SCR.RIE.
@ Setting SCR.TE and SCR.RE allows TXDn and RXDn to be used.
@ Not using interrupts so we'll be handling TE/RE in the read/write routines
  ldr r0, =AT_UART_BASE @ enable SCI1 TX/RX but not the interrupts
  mov r1, #0x30   @ [05]TE || [04]RE
  strb r1, [r0, #SCI_SCR]
  
  @ emit first byte so that TDRE polling works
  mov r1, #' '
  strb r1, [r0, #SCI_TDR]

NEXT

AT_CMD_END:
  .ascii "\r\n"

@ Execute AT command from string at addr on the ESP32, return the response string at addr2
@ Currently using the TIB for the response, we could allocate separate RAM space if necessary.
CODEWORD  "at", AT
@ (addr n -- addr2 n2 | -1 if error)

    @ send command
    ldr     r0, [DSP], #4          @ r0 = addr, TOS = n
    ldr     r1, =SCI1_BASE

at_tx_loop:
    cbz     TOS, at_cmd_done             @ If char count is 0, exit

at_tx_wait:
    ldrb     r2, [r1, #SCI_SSR]   @ Read SSR
    tst     r2, #SCI_SSR_TDRE           @ Test TDRE flag
    @ TODO: timeout?
    beq     at_tx_wait               @ Loop until TDRE == 1

    @ Clear TDRE flag (required on RA series before writing TDR)
    @ bic     r3, r3, #SCI_SSR_TDRE        @ Clear bit 7
    @ str     r3, [r1, #SCI_SSR]   @ Write back SSR

    ldrb    r2, [r0], #1             @ Load next byte, post-increment pointer
    strb    r2, [r1, #SCI_TDR]   @ Write byte to TDR
    b       at_tx_loop                 @ Next character

at_cmd_done:
    @ check if just sent command end string
    ldr r2, =AT_CMD_END+2
    cmp r0, r2
    beq at_tx_done
    ldr r0, =AT_CMD_END
    mov TOS, #2
    b at_tx_loop
at_tx_done:


    @ Read response, max refill_buf_size chars, use TOS to count received bytes
    ldr     r0, =RAM_lower_refill_buf   @ Store the response in TIB
    str     r0, [DSP, #-4]!             @ Store response address on DSP, TOS is 0
at_rx_loop:
    ldrb     r2, [r1, #SCI_SSR]   @ Read SSR
    tst     r2, #SCI_SSR_RDRF           @ Test RDRF flag
    @ TODO: timeout?
    beq     at_rx_loop             @ Loop until RDRF == 1 (data available)

    @ Optional: Check for errors
    tst     r2, #SCI_SSR_RERR
    beq     at_rx_no_error           @ No errors
    @ Handle errors
    bic     r2, r2, #SCI_SSR_RERR
    strb     r2, [r1, #SCI_SSR]   @ Clear error flags@ clear flags
    add DSP, DSP, #4    @ drop the address from the stack
    mvn TOS, #0         @ store -1 at the top of the stack
    b       at_rx_done                 @ Abort on error

at_rx_no_error:
    ldrb    r2, [r1, #SCI_RDR]   @ Read data from RDR (8-bit)

    @ Write to buffer
    strb    r2, [r0], #1            @ Store byte, increment pointer
    add     TOS, TOS, #1              @ Increment count

    @ Optional: Manual clear of RDRF (not always required, but safe)
    @ bic     r3, r3, #RDRF_BIT

    @ Check if max received or add timeout/termination logic
    cmp     r2, #'\n'               @ Stop if newline
    beq     at_rx_done
    ldr     r3, =refill_buf_size
    cmp     TOS, r3      @ Stop if max bytes
    beq     at_rx_done
    b     at_rx_loop                 @ Continue if not done
at_rx_done:
NEXT
