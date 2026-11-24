.globl isrstub
.globl _trap_restore # this is in exiti.s 

nullhandler: 1: j 1b 

faulthandler: 1: j 1b 

# Does not return. The trap frame, mcause, mepc and mtval are left for GDB.
_trap_exception:  1:  j 1b


isrstub:

	# QEMU has no HPE so all of the context is saved here. s11 is
	# reserved for this, so no scratch register is needed yet.
	# The s11 stack grows down. The frame is claimed by the first
	# instruction so a nested trap could not overwrite it.

	addi s11, s11, -TF_SIZE

	sw ra,    0(s11)
	sw t0,    4(s11)
	sw t1,    8(s11)
	sw t2,   12(s11)
	sw t3,   16(s11)
	sw t4,   20(s11)
	sw t5,   24(s11)
	sw t6,   28(s11)
	sw a0,   32(s11)
	sw a1,   36(s11)
	sw a2,   40(s11)
	sw a3,   44(s11)
	sw a4,   48(s11)
	sw a5,   52(s11)
	sw a6,   56(s11)
	sw a7,   60(s11)
	sw s1,   64(s11)
	sw s2,   68(s11)
	sw s3,   72(s11)
	sw s4,   76(s11)
	sw s5,   80(s11)
	sw s6,   84(s11)
	sw s7,   88(s11)
	sw s8,   92(s11)
	sw s9,   96(s11)
	sw s10, 100(s11)
	sw zero, TF_CLAIM(s11)

	# in-isr? counts the Forth handlers that are running, as on the
	# CH32. It is incremented on the Forth path below and decremented
	# at the top of exiti. Other paths enter exiti at _trap_restore.

	csrr t0, mcause                # exception codes overlap interrupt
	bltz t0, 1f                    # codes so they cannot share slots
	j _trap_exception

1:	slli t0, t0, 1                 # drop the interrupt bit
	srli t0, t0, 1                 # t0 has the interrupt code

	li t1, MCAUSE_MEI
	bne t0, t1, 2f

	li t1, PLIC_CLAIM              # external: the PLIC has the source
	lw t0, 0(t1)
	beqz t0, _trap_return          # spurious, nothing to complete
	sw t0, TF_CLAIM(s11)
	addi t0, t0, PLIC_SLOT_BASE

2:	li t1, TRAP_SLOTS
	bgeu t0, t1, _trap_return

	slli t0, t0, 2                 # t0 has byte offset into the tables

	la t1, RAM_lower_ram_vector    # check RAM trap table first
	add t1, t1, t0                 # 
	lw t2, 0(t1)                   #
	beqz t2, _trap_return          # if zero (currently) just exit cleanly 

	la t0, IN_ISRQ_ram             # one more Forth handler running
	lw t1, 0(t0)
	addi t1, t1, 1
	sw t1, 0(t0)

	mv s1, t2                      # XT of the Forth handler
	mv s7, zero                    # keep the debugger out of the handler
	j DO_EXECUTE                   # ;i compiles the return (exiti)

_trap_return:                      # the context restore is in exiti;
	j _trap_restore                # enter after the in-isr? decrement

