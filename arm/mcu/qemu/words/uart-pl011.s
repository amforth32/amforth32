/*
    PL011 UART

The QEMU virt machine for ARM uses a PL011 UART. Relevant registers are:

* UARTDR (Data Register): Offset 0x00. Used to write data to send and read received data.
* UARTFR (Flag Register): Offset 0x18. A read-only register that provides the status of the UART.
    * RXFE (Receive FIFO Empty): Bit 4. If this bit is 1, the receive FIFO is empty.
    * TXFF (Transmit FIFO Full): Bit 5. If this bit is 1, the transmit FIFO is full, and we cannot send more data until it has some space.
The base address for the UART on the virt machine is 0x09000000.
*/

.equ UART_BASE, 0x09000000
.equ UARTDR, 0x00
.equ UARTFR, 0x18
.equ UARTCR, 0x30
.equ RXFE, 1 << 4
.equ TXFF, 1 << 5

CODEWORD  "uart-init", UART_INIT
    @ ldr r1, =UART_BASE
    @ /* Enable UART (UARTEN), Transmit (TXEN), and Receive (RXEN) */
    @ ldr r0, =(1 << 0) | (1 << 8) | (1 << 9)
    @ str r0, [r1, #UARTCR]
    NEXT
END UART_INIT

CODEWORD  "serial-emit", SERIAL_EMIT
    ldr r1, =UART_BASE
tx_wait:
    /* Wait for the transmit FIFO to have space (TXFF bit 5 to be 0) */
    ldr r2, [r1, #UARTFR]
    tst r2, #TXFF 
    bne tx_wait

    /* Write the character to the Data Register */
    str TOS, [r1, #UARTDR]
    loadtos
    NEXT
END SERIAL_EMIT

CODEWORD  "serial-emit?", SERIAL_EMITQ
    savetos
    mov TOS, #0
    ldr r1, =UART_BASE
    ldr r2, [r1, #UARTFR]     
    tst r2, #TXFF
    bne 1f
    mvns TOS, TOS
1: 
    NEXT
END SERIAL_EMITQ

CODEWORD  "serial-key", SERIAL_KEY
    savetos
    ldr r1, =UART_BASE
rx_wait:
    /* Wait for the receive FIFO to have data (RXFE bit 4 to be 0) */
    ldr r2, [r1, #UARTFR]   
    tst r2, #RXFE 
    bne rx_wait

    /* Read the character from the Data Register */
    ldr TOS, [r1, #UARTDR]
    NEXT
END SERIAL_KEY

CODEWORD  "serial-key?", SERIAL_KEYQ
    savetos
    mov TOS, #0
    ldr r1, =UART_BASE
    ldr r2, [r1, #UARTFR]   
    tst r2, #RXFE 
    bne 1f
    mvns TOS, TOS
1: 
    NEXT
END SERIAL_KEYQ
