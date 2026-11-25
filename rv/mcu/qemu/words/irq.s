# SPDX-License-Identifier: GPL-3.0-only

# Individual interrupt enable for the QEMU virt machine.
#
# Slot numbers are the same as for trap!:
#    0-15   local interrupts, bit n of the mie CSR (3 = software, 7 = timer)
#   17-63   PLIC source n-16 (UART0 = 26, RTC = 27); PLIC source 0 does not exist
#
# +int / -int remain the global switch (mstatus.MIE).
# PLIC_BASE is defined in qemu.startup.

.equ PLIC_ENABLE , PLIC_BASE + 0x2000      # hart 0 M-mode context enable bits

.equ CLINT_BASE     , 0x02000000
.equ CLINT_MSIP     , CLINT_BASE           # hart 0
.equ CLINT_MTIMECMP , CLINT_BASE + 0x4000  # hart 0, low word
.equ CLINT_MTIME    , CLINT_BASE + 0xBFF8  # low word

CONSTANT "msip", MSIP, CLINT_MSIP /* ( -- addr ) CLINT: hart 0 software interrupt pending */
END MSIP


CODEWORD "irq.on", IRQ_ON /* ( n -- ) enable interrupt slot n, see trap!, throws if slot n has no handler */
    mv      t0, s3
    li      t1, 64               /* slots past 63 have no source */
    bgeu    t0, t1, 9f
    slli    t1, t0, 2            /* refuse a slot with no handler: */
    la      t2, RAM_lower_ram_vector
    add     t1, t1, t2           /* the source would trap forever */
    lw      t1, 0(t1)
    beqz    t1, 8f
    loadtos
    li      t1, 16
    bgeu    t0, t1, 1f

    li      t1, 1                /* local: set bit n of mie */
    sll     t1, t1, t0
    csrs    mie, t1
    NEXT

1:  li      t1, 64
    bgeu    t0, t1, 9f
    addi    t0, t0, -16          /* t0 = PLIC source id */
    beqz    t0, 9f

    li      t1, PLIC_BASE        /* priority 1 so it beats threshold 0 */
    slli    t2, t0, 2
    add     t1, t1, t2
    li      t2, 1
    sw      t2, 0(t1)

    li      t1, PLIC_ENABLE      /* set the source's enable bit */
    srli    t2, t0, 5
    slli    t2, t2, 2
    add     t1, t1, t2
    andi    t2, t0, 31
    li      a0, 1
    sll     a0, a0, t2
    lw      t2, 0(t1)
    or      t2, t2, a0
    sw      t2, 0(t1)

    li      t1, 0x800            /* mie.MEIE: let the PLIC through */
    csrs    mie, t1
    NEXT

8:  throw   ENOISR               /* no handler in the slot */
9:  throw   -24                  /* invalid numeric argument */
END IRQ_ON

CODEWORD "irq.off", IRQ_OFF /* ( n -- ) disable interrupt slot n, see trap! */
    mv      t0, s3
    loadtos
    li      t1, 16
    bgeu    t0, t1, 1f

    li      t1, 1                /* local: clear bit n of mie */
    sll     t1, t1, t0
    csrc    mie, t1
    NEXT

1:  li      t1, 64
    bgeu    t0, t1, 9f
    addi    t0, t0, -16          /* t0 = PLIC source id */
    beqz    t0, 9f

    li      t1, PLIC_ENABLE      /* clear the source's enable bit; */
    srli    t2, t0, 5            /* mie.MEIE stays on for other sources */
    slli    t2, t2, 2
    add     t1, t1, t2
    andi    t2, t0, 31
    li      a0, 1
    sll     a0, a0, t2
    not     a0, a0
    lw      t2, 0(t1)
    and     t2, t2, a0
    sw      t2, 0(t1)
    NEXT

9:  throw   -24                  /* invalid numeric argument */
END IRQ_OFF
