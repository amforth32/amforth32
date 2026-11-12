\ interrupt test script for MPS2 (Cortex-M only)
\ run QEMU with second serial attached, e.g -serial file:uart1.bin,
\ for example as > ARGS='-serial file:uart1.bin' make pty

\ seed for the random generator
variable seed
$12345678 seed !

: random ( -- n ) \ generate random number
  seed @ 31421 * 6927 + dup seed !
;

uart1 uart-init \ initialize UART1

: isr \ exercise the stacks and make results observable on uart1
    random uart1 uart-emit
;i

\ set systick to trigger interrupt every 200 ms
systick.ms 200 * systick!


\ attach the isr to systick interrupt
' isr systick# trap!

+systick    \ make sure systick is enabled
+int        \ enable interrupts


3000 ms     \ wait 3000 ms

-int        \ disable interrupts
systick.max \ restore normal systick reload setup
