.globl isrstub
.globl _trap_restore # this is in exiti.s 

nullhandler: 1: j 1b 

faulthandler: 1: j 1b 

# Does not return. The trap frame, mcause, mepc and mtval are left for GDB.
_trap_exception:  1:  j 1b


isrstub:

	# QEMU has no HPE so all of the context is saved here, on
	# ISR_stack. s11 points at the current frame; it is reserved, so
	# no scratch register is needed yet. MIE is 0 until the handler
	# runs +int, so nothing here can be interrupted.
	#
	# Like ARM, the handler gets ISR_stack as its return stack:
	#
	#   ISR_stack top          <- s11 when no handler is running
	#     [ frame ]            <- s11 in the handler
	#     [ handler RS ... ]   <- s5 in the handler
	#     [ saved s11 ]        nested trap: pushed on the handler RS
	#     [ nested frame ]     <- s11 in the nested handler
	#     [ nested RS ... ]
	#
	# The old s11 is pushed on the interrupted return stack (the
	# task's, or the outer handler's when nested) and popped by
	# (exiti).
	#
	# Each new frame goes into free space, just below whatever stack
	# is in use:
	#   - a task was interrupted: its RS lies above ISR_stack, so all
	#     of ISR_stack is free and the frame goes at s11 (its top).
	#   - a handler was interrupted: its RS is inside ISR_stack. From
	#     s11 down to s5 is in use (its RS entries and the s11 just
	#     pushed); below s5 is free. s5 is the first free address, so
	#     the frame goes there.
	# bgeu s5, s11 tells the two apart (s5 at or above s11: a task;
	# below: a handler) without needing a scratch register. It relies
	# on every task RS lying above ISR_stack: core/amforth32.s
	# allocates ISR_stack first, and the .if at the end of
	# rv/mcu/qemu/amforth.s checks it.

	push s11                       # old s11 on the interrupted RS
	bgeu s5, s11, 1f               # task: all of ISR_stack is free
	mv   s11, s5                   # handler: s5 is the first free address
1:	addi s11, s11, -TF_SIZE

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

	csrr t0, mepc                  # a nested trap overwrites these,
	sw t0, TF_MEPC(s11)            # so they go in the frame too
	csrr t0, mstatus
	sw t0, TF_MSTATUS(s11)

	# in-isr? counts the Forth handlers that are running (CH32 does
	# the same in _master_int). It is incremented on the Forth path below and decremented
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
	mv s5, s11                     # handler RS starts below its frame
	j DO_EXECUTE                   # ;i compiles the return (exiti)

_trap_return:                      # the context restore is in exiti;
	j _trap_restore                # enter after the in-isr? decrement

