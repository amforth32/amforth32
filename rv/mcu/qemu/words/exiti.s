# SPDX-License-Identifier: GPL-3.0-only

HEADLESS "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */

     # QEMU has no HPE: restore the whole frame saved by _master_int

     /* one less Forth handler running (in-isr? is a count) */

     la      t0, IN_ISRQ_ram
     lw      t1, 0(t0)
     addi    t1, t1, -1
     sw      t1, 0(t0)

     /*
        the flash handler, spurious and out-of-range paths did not
        count themselves in in-isr?, so they enter here
     */

_trap_restore:

     /* complete any claimed PLIC source */

     lw      t0, TF_CLAIM(s11)
     beqz    t0, 1f
     li      t1, PLIC_CLAIM
     sw      t0, 0(t1)
1:

     lw ra,    0(s11)
     lw t0,    4(s11)
     lw t1,    8(s11)
     lw t2,   12(s11)
     lw t3,   16(s11)
     lw t4,   20(s11)
     lw t5,   24(s11)
     lw t6,   28(s11)
     lw a0,   32(s11)
     lw a1,   36(s11)
     lw a2,   40(s11)
     lw a3,   44(s11)
     lw a4,   48(s11)
     lw a5,   52(s11)
     lw a6,   56(s11)
     lw a7,   60(s11)
     lw s1,   64(s11)
     lw s2,   68(s11)
     lw s3,   72(s11)
     lw s4,   76(s11)
     lw s5,   80(s11)
     lw s6,   84(s11)
     lw s7,   88(s11)
     lw s8,   92(s11)
     lw s9,   96(s11)
     lw s10, 100(s11)

     /* release the frame last, so a nested trap could not overwrite it */

     addi s11, s11, TF_SIZE

     mret
END EXITI
