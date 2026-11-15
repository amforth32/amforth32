\ Enable a relatively frequent timer interrupt,
\ that can be used to hammer the test suite run with IRQs
\ Cortex-M only for now

-int
-systick

\ Preserve the previous systick handler
variable irq_old_handler
systick# trap@ irq_old_handler !

\ use a 10 ms SysTick period.
systick.ms * 10 systick!
+systick

:noname 100 0 do i drop loop ;i systick# trap!
+int
