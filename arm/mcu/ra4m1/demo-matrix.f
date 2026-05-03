-int
single
led-off

#include ./lib/gpio.f
#include ./lib/matrix.f

variable m.ftau   \ m ms taken per frame
variable m.fadv   \ advance every n frames 

: isr
    systick- 1 m.cnt +! m.frame
    m.cnt @ m.fadv @ = if
        1 m.offset @ + m.max @ mod m.offset !
        0 m.cnt !
    then
;i

  
: isr.init
    systick.init ['] isr systick# trap!
;

: xx begin mandelbrot key? until ;

: demo
    3 m.ftau !    \ m ms taken per frame
    100 m.fadv !  \ advance every n frames
    
\      123456789A123456789A123456
    s" abcdefghijklmnopqrstuvwxyz" m.load
    
    0 m.offset ! \ init 
    0 m.cnt !    \
    
    -int
    isr.init #48000 m.ftau @ * systick! +systick
    +int
;

\ do not run zz in shell 
: zz
    begin
        mandelbrot
    key? until
;

demo






