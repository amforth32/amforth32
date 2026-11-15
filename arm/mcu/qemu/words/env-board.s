
ENVIRONMENT "board", BOARD /* ( -- addr u ) string with board identifier */
.if TARGET_VIRT == YES
  STRING "QEMU-VIRT"
.else
  STRING "QEMU-MPS2"
.endif
  .word XT_EXIT
END BOARD
