
ENVIRONMENT "cpu", CPU /* ( -- addr u ) string with cpu identifier */
.if TARGET_VIRT == YES
  STRING "CORTEX-A15"
.else
  STRING "CORTEX-M4"
.endif
  .word XT_EXIT
END CPU
