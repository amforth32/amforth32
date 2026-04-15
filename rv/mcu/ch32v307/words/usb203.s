# SPDX-License-Identifier: GPL-3.0-only
# ============================================
# CH32V203 USBFS/OTG_FS Register Definitions
# ============================================

# USBOTG_FS Base Address (check your reference manual Chapter 23)
.equ USBOTG_FS_BASE,    0x50000000  # Typical OTG_FS base for CH32V

# Core Global Registers
.equ USB_GOTGCTL,       0x000       # OTG control and status
.equ USB_GOTGINT,       0x004       # OTG interrupt
.equ USB_GAHBCFG,       0x008       # AHB configuration
.equ USB_GUSBCFG,       0x00C       # USB configuration  
.equ USB_GRSTCTL,       0x010       # Reset
.equ USB_GINTSTS,       0x014       # Core interrupt
.equ USB_GINTMSK,       0x018       # Interrupt mask
.equ USB_GRXSTSR,       0x01C       # Receive status debug read
.equ USB_GRXSTSP,       0x020       # Receive status read/pop
.equ USB_GRXFSIZ,       0x024       # Receive FIFO size
.equ USB_DIEPTXF0,      0x028       # EP0 TX FIFO size
.equ USB_GCCFG,         0x038       # General core configuration

# Device Mode Registers  
.equ USB_DCFG,          0x800       # Device configuration
.equ USB_DCTL,          0x804       # Device control
.equ USB_DSTS,          0x808       # Device status
.equ USB_DIEPMSK,       0x810       # Device IN endpoint common interrupt mask
.equ USB_DOEPMSK,       0x814       # Device OUT endpoint common interrupt mask
.equ USB_DAINT,         0x818       # Device all endpoints interrupt
.equ USB_DAINTMSK,      0x81C       # All endpoints interrupt mask
.equ USB_DVBUSDIS,      0x828       # Device VBUS discharge time
.equ USB_DVBUSPULSE,    0x82C       # Device VBUS pulsing time

# Device Endpoint Registers (EP0)
.equ USB_DIEPCTL0,      0x900       # Device IN endpoint 0 control
.equ USB_DIEPINT0,      0x908       # Device IN endpoint 0 interrupt
.equ USB_DIEPTSIZ0,     0x910       # Device IN endpoint 0 transfer size
.equ USB_DTXFSTS0,      0x918       # Device IN endpoint 0 TX FIFO status
.equ USB_DOEPCTL0,      0xB00       # Device OUT endpoint 0 control
.equ USB_DOEPINT0,      0xB08       # Device OUT endpoint 0 interrupt
.equ USB_DOEPTSIZ0,     0xB10       # Device OUT endpoint 0 transfer size

# FIFO Access
.equ USB_FIFO0,         0x1000      # EP0 FIFO

# ============================================
# USB Data Buffers
# ============================================

.section .bss
.align 4
usb_rx_buffer:
    .space 64
usb_tx_buffer:
    .space 64


# ============================================
# USB Descriptors (in .rodata section)
# ============================================

.section .rodata
.align 2

device_descriptor:
    .byte 18, 1                 # bLength, bDescriptorType
    .byte 0x00, 0x02            # USB 2.0
    .byte 0, 0, 0, 64           # Class, SubClass, Protocol, MaxPacket
    .byte 0x86, 0x1A            # VID 0x1A86 (WCH)
    .byte 0x34, 0x12            # PID 0x1234
    .byte 0x00, 0x01            # Device release 1.0
    .byte 1, 2, 0, 1            # iManufacturer, iProduct, iSerial, NumConfigs

config_descriptor:
    .byte 9, 2                  # bLength, bDescriptorType
    .byte 9, 0                  # wTotalLength (9 bytes)
    .byte 0, 1, 0               # NumInterfaces, ConfigValue, iConfiguration
    .byte 0x80, 50              # Attributes (bus-powered), MaxPower (100mA)

# ============================================
# USB Functions (in .text section)
# ============================================

.section .text

# --------------------------------------------
# usb_init - Initialize USB peripheral
# Arguments: none
# Returns: none
# Uses: t0, t1, t2
# --------------------------------------------
.globl usb_init
usb_init:
    # Enable USB clock
    li t0, RCC_APB1PCENR
    lw t1, 0(t0)
    li t2, 0x00800000
    or t1, t1, t2
    sw t1, 0(t0)
    
    # Reset USB peripheral
    li t0, USB_BASE
    sb zero, USB_CTRL(t0)
    
    # Delay for reset
    li t1, 10000
1:  addi t1, t1, -1
    bnez t1, 1b
    
    # Enable USB with pullup
    li t1, 0x29
    sb t1, USB_CTRL(t0)
    
    # Set EP0 DMA buffer
    la t1, ep0_buffer
    sw t1, UEP0_DMA(t0)
    
    # Configure EP0: RX+TX enable
    li t1, 0x02
    sb t1, UEP4_1_MOD(t0)
    
    # EP0 control: ready to receive
    li t1, 0xC0
    sb t1, UEP0_CTRL(t0)
    
    # Enable USB interrupts
    li t1, 0x8F
    sb t1, USB_INT_EN(t0)
    
    ret

# --------------------------------------------
# usb_send_descriptor - Send descriptor on EP0
# Arguments: a0 = descriptor address
#            a1 = descriptor length
# Returns: none
# Uses: t0, t1, t2, t3
# --------------------------------------------
usb_send_descriptor:
    li t0, USB_BASE
    la t1, ep0_buffer
    addi t1, t1, 64             # TX buffer at offset 64
    
    # Limit to 64 bytes
    li t2, 64
    blt a1, t2, 1f
    li a1, 64
    
1:  # Copy descriptor to TX buffer
    mv t3, a1
2:  beqz t3, 3f
    lb t2, 0(a0)
    sb t2, 0(t1)
    addi a0, a0, 1
    addi t1, t1, 1
    addi t3, t3, -1
    j 2b
    
3:  # Trigger transmission
    li t1, 0x40
    or t1, t1, a1
    sb t1, UEP0_CTRL(t0)
    ret

# --------------------------------------------
# usb_handle_setup - Handle SETUP packet
# Arguments: none
# Returns: none
# Uses: t0-t6, a0, a1
# --------------------------------------------
usb_handle_setup:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, USB_BASE
    la t1, ep0_buffer
    
    # Get bRequest
    lb t2, 1(t1)
    
    # Check for GET_DESCRIPTOR (0x06)
    li t3, 0x06
    bne t2, t3, check_set_address
    
    # Get descriptor type from wValue high byte
    lb t2, 3(t1)
    
    # Device descriptor (type 1)
    li t3, 1
    bne t2, t3, check_config_desc
    la a0, device_descriptor
    li a1, 18
    call usb_send_descriptor
    j setup_done
    
check_config_desc:
    # Config descriptor (type 2)
    li t3, 2
    bne t2, t3, stall_ep0
    la a0, config_descriptor
    li a1, 9
    call usb_send_descriptor
    j setup_done
    
check_set_address:
    # Check for SET_ADDRESS (0x05)
    li t3, 0x05
    bne t2, t3, stall_ep0
    
    # Get address from wValue
    lb t2, 2(t1)
    sb t2, USB_DEV_AD(t0)
    
    # Send zero-length ACK
    li t2, 0x40
    sb t2, UEP0_CTRL(t0)
    j setup_done
    
stall_ep0:
    # Stall EP0 for unknown requests
    li t2, 0xC3
    sb t2, UEP0_CTRL(t0)
    
setup_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --------------------------------------------
# USB_IRQHandler - USB interrupt handler
# Arguments: none
# Returns: none
# Uses: t0-t4, a0, a1
# --------------------------------------------
.globl USB_IRQHandler
.align 2
USB_IRQHandler:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw t0, 0(sp)
    
    li t0, USB_BASE
    lb t1, USB_INT_FG(t0)       # Read interrupt flags
    lb t2, USB_INT_ST(t0)       # Read interrupt status
    
    # Check for USB reset (bit 4)
    andi t3, t1, 0x10
    beqz t3, check_transfer
    
    # Handle USB reset
    sb zero, USB_DEV_AD(t0)     # Reset device address
    li t3, 0xC0
    sb t3, UEP0_CTRL(t0)        # Reset EP0 control
    
check_transfer:
    # Check for transfer complete (bits 0-1)
    andi t3, t1, 0x03
    beqz t3, clear_flags
    
    # Check if it's a SETUP token on EP0
    andi t3, t2, 0x0F
    li t4, 0x06                 # SETUP token
    bne t3, t4, clear_flags
    
    # Handle SETUP packet
    call usb_handle_setup
    
clear_flags:
    # Clear interrupt flags
    sb t1, USB_INT_FG(t0)
    
    lw t0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    mret                        # Return from interrupt

# ============================================
# Optional: Simple test/demo function
# ============================================

.globl usb_test
usb_test:
    call usb_init
    
    # Enable global interrupts if needed
    # (depends on your existing startup code)
    
test_loop:
    wfi
    j test_loop