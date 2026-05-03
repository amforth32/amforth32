\ ======================================================================
\ LED MATRIX 8 ROWS by 12 COLUMNS CHARLIEPLEXED 
\ ======================================================================

\ The charliplex array is modeled as an array of leds, each with a
\ cartesian position (row,col)

\ (0,0) ..... (0,11)
\ .
\ .
\ .
\ (7,0) ..... (7,11)

\ To light an LED need to know which of the (internal) pins M00..M10 to
\ make high and which make low (having first made all of M00..M10 high z
\ - inputs) This is provided by m.map which is a lookup table. The entry
\ for row*12+col is a byte with the high pin number in the upper nibble
\ and the low pin number in the lower nibble. So (0,0) maps to M07 high
\ and M03 low etc. 

create m.map 
$73 c, $37 c, $74 c, $47 c, $34 c, $43 c, $78 c, $87 c, $38 c, $83 c, $48 c, $84 c,
$70 c, $07 c, $30 c, $03 c, $40 c, $04 c, $80 c, $08 c, $76 c, $67 c, $36 c, $63 c,
$46 c, $64 c, $86 c, $68 c, $06 c, $60 c, $75 c, $57 c, $35 c, $53 c, $45 c, $54 c,
$85 c, $58 c, $05 c, $50 c, $65 c, $56 c, $71 c, $17 c, $31 c, $13 c, $41 c, $14 c,
$81 c, $18 c, $01 c, $10 c, $61 c, $16 c, $51 c, $15 c, $72 c, $27 c, $32 c, $23 c,
$42 c, $24 c, $82 c, $28 c, $02 c, $20 c, $62 c, $26 c, $52 c, $25 c, $12 c, $21 c,
$7a c, $a7 c, $3a c, $a3 c, $4a c, $a4 c, $8a c, $a8 c, $0a c, $a0 c, $6a c, $a6 c,
$5a c, $a5 c, $1a c, $a1 c, $2a c, $a2 c, $79 c, $97 c, $39 c, $93 c, $49 c, $94 c,

: m.highz \# ( -- ) Make all internal pins M00..M10 high Z - inputs 
    0 $4004080c ! 0 $40040810 ! 0 $4004082c ! 0 $40040830 !
    0 $40040834 ! 0 $4004083c ! 0 $40040890 ! 0 $40040894 !
    0 $40040898 ! 0 $400408b0 ! 0 $400408b4 !
;

\ set internal charlieplex pin Mn high or low where n=0..10 from M00..M10
\ this relies on M00..M10 starting at row #20 in the gpio table 

: m.high ( n -- ) #20 + 5 swap gpio.pfs ! ;
: m.low  ( n -- ) #20 + 4 swap gpio.pfs ! ;

: m.led \# ( i j -- ) turn on LED array (row=i,col=j) 
    m.highz
    swap #12 * + m.map + c@   \ find (row=i,col=j)
    dup #4 rshift m.high      \ high nibble is high
        %1111 and m.low       \  low nibble is low 
;

#26 constant max.len  \ max length in bytes of string to scroll
variable m.offset     \ start col in m.buf for frame to show 
variable m.size       \ (calc) size of m.buf 
variable m.max        \ (calc) end point 
variable m.cnt        \ (calc)  
variable m.buf max.len 3 + 6 * aligned cells dup m.size ! allot

: m.frame \# ( -- ) display the 12 column/byte frame in m.buf starting at m.offset
    #12 0 do
        m.offset @ m.buf + i + 8 0 do
            dup c@ 1 i lshift and if i j m.led then
        loop drop
    loop 
    m.highz
;

: m.load \# ( a n -- ) generate contents of m.but from string a n 
    dup >r m.buf m.size @ $00 fill
    r> 6 * m.max !
    max.len min 0 ?do
        dup i + c@ 6 * font + m.buf i 2+ 6 * + 6 move
    loop drop
;

\ ----------------------------------------------------------------------

\ retain as basic example 

\ variable m.ftau   \ 
\ variable m.fadv   \ number of frame tau 

\ : isr
\     1 m.cnt +! 
\     systick- m.frame
\     m.cnt @ m.fadv @ = if
\         1 m.offset @ + m.max @ mod m.offset !
\         0 m.cnt !
\     then
\ ;i

\ : isr.init
\     systick.init ['] isr systick# trap!
\ ;

\ : demo
\     5 m.ftau !   \ m ms per frame
\     20 m.fadv !  \ advance every n frames
    
\     s" abcdefghijklmnopqrstuvwxyz" m.load

\     0 m.offset ! \ init 
\     0 m.cnt !    \
    
\     -int
\     isr.init #48000 m.ftau @ * systick! +systick
\     +int
\ ;

\ ----------------------------------------------------------------------