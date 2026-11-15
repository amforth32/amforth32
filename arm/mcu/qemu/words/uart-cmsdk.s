/*
    UART from Cortex-M System Design Kit

The QEMU mps2 machines for ARM use CMSDK UARTs. Relevant registers are:

Name    | Base offset | Type | Width | Reset value |  Description
--------------------------------------------------------------
DATA    0x000       RW      8       0x--            [7:0]   Data value.
                                                    Read    Received data.
                                                    Write   Transmit data.
STATE   0x004       RW      4       0x0             [3] RX buffer overrun, write 1 to clear.
                                                    [2] TX buffer overrun, write 1 to clear.
                                                    [1] RX buffer full, read-only.
                                                    [0] TX buffer full, read-only.
CTRL    0x008       RW      7       0x00            [6] High-speed test mode for TX only.
                                                    [5] RX overrun interrupt enable.
                                                    [4] TX overrun interrupt enable.
                                                    [3] RX interrupt enable.
                                                    [2] TX interrupt enable.
                                                    [1] RX enable.
                                                    [0] TX enable.
INTSTATUS 0x00C     RW      4       0x0             [3] RX overrun interrupt. Write 1 to clear.
INTCLEAR                                            [2] TX overrun interrupt. Write 1 to clear.
                                                    [1] RX interrupt. Write 1 to clear.
                                                    [0] TX interrupt. Write 1 to clear.
BAUDDIV   0x010     RW      20      0x00000 [       19:0] Baud rate divider. The minimum number is 16.
-----------------------------------------------------------------------------------

The base addresses/IRQs for the UART on the msp2-an385/386 machines are.

Device | Base Address | Combined TX/RX	| Individual TX/RX
--------------------------------------------------------------
UART0	0x40004000	    IRQ 0	          TX: IRQ 1 / RX: IRQ 0
UART1	0x40005000	    IRQ 2	          TX: IRQ 3 / RX: IRQ 2
UART2	0x4002C000	    IRQ 45	          Combined via OR-gate
UART3	0x4002D000	    IRQ 46	          Combined via OR-gate
UART4	0x4002E000	    IRQ 56	          Combined via OR-gate
--------------------------------------------------------------

Interrupt Routing Details
* Combined TX/RX Lines: In QEMU's implementation, the TX and RX interrupt lines for each APB UART
  are routed into an internal OR-gate (TYPE_OR_IRQ) that raises the respective combined line listed in the table above.
* UART0 & UART1 Distinction: On the physical AN385/AN386 reference designs, UART0 and UART1 provide
  split transmit and receive lines (RX on IRQ 0/2, TX on IRQ 1/3) as well as combined interrupt options;
  QEMU wires the OR-gated combined output directly to the primary interrupt indices (0 and 2).

https://support.arm.com/documentation/ddi0479/d/introduction/about-the-cortex-m-system-design-kit

*/

.equ UART0,	0x40004000
.equ UART1,	0x40005000
.equ UART2,	0x4002C000
.equ UART3,	0x4002D000
.equ UART4,	0x4002E000

# These symbols are local to this file (.eqv)
.eqv DATA, 0x00
.eqv STATE, 0x04
.eqv CTRL, 0x08
.eqv BAUDDIV, 0x10
.eqv RXBF, 1 << 1
.eqv TXBF, 1 << 0


CODEWORD  "uart-init", UART_INIT /* ( a -- ) enable UART with base address a */
    poptos r1

    /* 1. Configure the Baud Rate */
    /* Formula: PCLK / Baud Rate = Divider Value */
    /* The mps2 clock runs at 12,000,000 Hz. For 9600 Baud: */
    /* 12,000,000 / 9600 = 1250 (0x4E2) */
    @ ldr     r2, =1250
    @ str     r2, [r1, #BAUDDIV]

    /* 2. Enable TX and RX in the Control Register */
    /* Bit 0 (TXEN) = 1, Bit 1 (RXEN) = 1 */
    mov     r2, #3
    str     r2, [r1, #CTRL]
    NEXT
END UART_INIT

CODEWORD  "uart-emit", UART_EMIT /* ( c a -- ) emit c on UART with base address a */ 
    poptos r1
tx_wait:
    /* Wait for the transmit FIFO to have space (TXFF bit 5 to be 0) */
    ldr r2, [r1, #STATE]
    tst r2, #TXBF
    bne tx_wait

    /* Write the character to the Data Register */
    str TOS, [r1, #DATA]
    loadtos
    NEXT
END UART_EMIT

CODEWORD  "uart-emit?", UART_EMITQ /* ( a -- f ) check if UART with base address a is ready to transmit */ 
    mov r1, TOS
    mov TOS, #0
    ldr r2, [r1, #STATE]     
    tst r2, #TXBF
    bne 1f
    mvns TOS, TOS
1: 
    NEXT
END UART_EMITQ

CODEWORD  "uart-key", UART_KEY /* ( a -- c ) receive c from  UART with base address a */ 
    mov r1, TOS
rx_wait:
    ldr r2, [r1, #STATE]   
    tst r2, #RXBF 
    beq rx_wait

    /* Read the character from the Data Register */
    ldr TOS, [r1, #DATA]
    and     r0, r0, #0xFF  @ mask out upper bits
    NEXT
END UART_KEY

CODEWORD  "uart-key?", UART_KEYQ /* ( a -- f ) check if UART with base address a has data to read */
    mov r1, TOS
    mov TOS, #0
    ldr r2, [r1, #STATE]   
    tst r2, #RXBF
    beq 1f
    mvns TOS, TOS
1: 
    NEXT
END UART_KEYQ

/*
    Tie the standard I/O words to UART0
*/

CONSTANT "uart0", UART0, UART0
END UART0

CONSTANT "uart1", UART1, UART1
END UART1

CONSTANT "uart2", UART2, UART2
END UART2

CONSTANT "uart3", UART3, UART3
END UART3

CONSTANT "uart4", UART4, UART4
END UART4

COLON  "serial-emit", SERIAL_EMIT
    .word XT_DOLITERAL, UART0, XT_UART_EMIT, XT_EXIT
END SERIAL_EMIT

COLON  "serial-emit?", SERIAL_EMITQ
    .word XT_DOLITERAL, UART0, XT_UART_EMITQ, XT_EXIT
END SERIAL_EMITQ

COLON  "serial-key", SERIAL_KEY
    .word XT_DOLITERAL, UART0, XT_UART_KEY, XT_EXIT
END SERIAL_KEY

COLON  "serial-key?", SERIAL_KEYQ
    .word XT_DOLITERAL, UART0, XT_UART_KEYQ, XT_EXIT
END SERIAL_KEYQ
