#======================================================================
# vectors.s -- flash trap table, QEMU virt (64 slots, one per line)
#
# isrstub turns every interrupt into a SLOT number:
#
#   slots  0..15   CORE interrupts      slot = mcause code
#                  (mcause with bit 31 cleared). Raised in the hart
#                  itself: software (CLINT msip), timer (CLINT
#                  mtimecmp), external (the PLIC as a whole).
#
#   slots 16..63   PLIC sources         slot = 16 + PLIC source id
#                  (PLIC_SLOT_BASE). Every device interrupt reaches
#                  the hart as ONE core interrupt, MEI (code 11).
#                  isrstub reads PLIC_CLAIM to find which source it
#                  was and uses that source's slot here instead.
#
#   Never dispatched:
#     slot 11  MEI is always redirected to its PLIC slot
#     slot 16  PLIC source 0 = "nothing pending"; isrstub returns
#
# Exceptions (mcause bit 31 = 0) never come here: _trap_exception.
#
# Handlers are ordinary ABI functions: they end in ret, not mret.
#
# Default_Handler is isrstub: every slot without its own handler
# points at the common trap entry. (Defined here only; do not also
# define a Default_Handler label in qemu.startup.)
#
# NOTE: isrstub currently checks only the RAM trap! table and returns
#       when that slot is zero; it does not fall back to this table.
#======================================================================

.section .vector,"ax"
.p2align 2
_vector_base:

#---- CORE interrupts: slot = mcause code ------------------------------
	 j nullhandler   #  0  reserved
	 j isrstub       #  1  S-mode software     (unused, M-mode only)
	 j isrstub       #  2  reserved
	 j isrstub       #  3  M-mode software     CLINT msip
	 j nullhandler   #  4  reserved
	 j isrstub       #  5  S-mode timer        (unused)
	 j nullhandler   #  6  reserved
	 j isrstub       #  7  M-mode timer        CLINT mtimecmp
	 j nullhandler   #  8  reserved
	 j isrstub       #  9  S-mode external     (unused)
	 j nullhandler   # 10  reserved
	 j isrstub       # 11  M-mode external     never: -> PLIC slot
	 j nullhandler   # 12  reserved
	 j isrstub       # 13  counter overflow    (unused)
	 j nullhandler   # 14  reserved
	 j nullhandler   # 15  reserved

#---- PLIC sources: slot = 16 + source id ------------------------------
#     slot  src
	# .word isrstub       # 16    0  none: claim 0 = nothing pending
	# .word isrstub       # 17    1  virtio-mmio 0
	# .word isrstub       # 18    2  virtio-mmio 1
	# .word isrstub       # 19    3  virtio-mmio 2
	# .word isrstub       # 20    4  virtio-mmio 3
	# .word isrstub       # 21    5  virtio-mmio 4
	# .word isrstub       # 22    6  virtio-mmio 5
	# .word isrstub       # 23    7  virtio-mmio 6
	# .word isrstub       # 24    8  virtio-mmio 7
	# .word isrstub       # 25    9  -
	# .word isrstub       # 26   10  UART0 (ns16550a)
	# .word isrstub       # 27   11  RTC (goldfish)
	# .word isrstub       # 28   12  -
	# .word isrstub       # 29   13  -
	# .word isrstub       # 30   14  -
	# .word isrstub       # 31   15  -
	# .word isrstub       # 32   16  -
	# .word isrstub       # 33   17  -
	# .word isrstub       # 34   18  -
	# .word isrstub       # 35   19  -
	# .word isrstub       # 36   20  -
	# .word isrstub       # 37   21  -
	# .word isrstub       # 38   22  -
	# .word isrstub       # 39   23  -
	# .word isrstub       # 40   24  -
	# .word isrstub       # 41   25  -
	# .word isrstub       # 42   26  -
	# .word isrstub       # 43   27  -
	# .word isrstub       # 44   28  -
	# .word isrstub       # 45   29  -
	# .word isrstub       # 46   30  -
	# .word isrstub       # 47   31  -
	# .word isrstub       # 48   32  PCIe INTA
	# .word isrstub       # 49   33  PCIe INTB
	# .word isrstub       # 50   34  PCIe INTC
	# .word isrstub       # 51   35  PCIe INTD
	# .word isrstub       # 52   36  -
	# .word isrstub       # 53   37  -
	# .word isrstub       # 54   38  -
	# .word isrstub       # 55   39  -
	# .word isrstub       # 56   40  -
	# .word isrstub       # 57   41  -
	# .word isrstub       # 58   42  -
	# .word isrstub       # 59   43  -
	# .word isrstub       # 60   44  -
	# .word isrstub       # 61   45  -
	# .word isrstub       # 62   46  -
	# .word isrstub       # 63   47  -

#---- size check: must match TRAP_SLOTS in qemu.startup ----------------
#.if (. - _vector_base) != (TRAP_SLOTS * 4)
#	.error "vectors.s: table size does not match TRAP_SLOTS"
#.endif

#----------------------------------------------------------------------
