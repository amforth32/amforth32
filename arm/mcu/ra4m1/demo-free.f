-int
single
led-off

#include lib/gpio.f 

: isr
   systick- 
   led? if led-off else led-on then
;i

: isr.init
    systick.init
    48000 systick!
    ['] isr systick# trap!                           \ 500 Hz
;

: led-100 D07~ begin D07+  10 ms D07-  10 ms again ; \  50 Hz
: led-10  D06~ begin D06+ 100 ms D06- 100 ms again ; \   5 Hz

' led-100 1 task! 1 +task
' led-10  2 task! 2 +task

isr.init
+systick
+int
multi

: zz
    begin
        mandelbrot
    key? until
;

