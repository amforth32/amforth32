
led-off

: isr systick-
    led? if led-off else led-on then
;i

: isr.init
    systick.init
    ['] isr systick# trap!
;

isr.init
+systick
+int

\ should be a ~1.4Hz flashing LED on D13


