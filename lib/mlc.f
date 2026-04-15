\ >flash
decimal
\ empty

\ include ./vt100.frt
\ https://github.com/martin-h1/forth-cs-101/blob/master/mandelbrot.fs
\ setup constants to remove magic numbers to allow
\ for greater zoom with different scale factors.
20  constant maxiter
\ -39 constant minval
\ 40  constant maxval
-19 constant minval
20  constant maxval
640 constant rescale
2560 constant s_escape

\ these variables hold values during the escape calculation.
variable creal
variable cimag
variable zreal
variable zimag
variable ccount

: */ >r * r> / ; 

\ compute squares, but rescale to remove extra scaling factor.
: zr_sq zreal @ dup rescale */ ;
: zi_sq zimag @ dup rescale */ ;

\ translate escape count to ascii greyscale.
: .char
   s" ..,'~!^:;[/<&?oxox#   "
   drop + 1
   $20 emit type ;


\ numbers above 4 will always escape, so compare to a scaled value.
: escapes?
  s_escape > ;

\ increment count and compare to max iterations.
: count_and_test?
  ccount @ 1+ dup ccount !
  maxiter > ;

\ stores the row column values from the stack for the escape calculation.
: init_vars
  5 lshift dup creal ! zreal !
  5 lshift dup cimag ! zimag !
  1 ccount ! ;



\ performs a single iteration of the escape calculation.
: doescape
    zr_sq zi_sq 2dup +
    escapes? if
      2drop
      true
    else
      - creal @ +   \ leave result on stack
      zreal @ zimag @ rescale */ 1 lshift
      cimag @ + zimag !
      zreal !                   \ store stack item into zreal
      count_and_test?
    then ;

\ iterates on a single cell to compute its escape factor.
: docell
  init_vars
  begin
    doescape
  until
  ccount @
  .char ;

\ for each cell in a row.
: dorow
    space space space 
  maxval minval do
    dup i
    docell
  loop
  drop ;

\ for each row in the set.
: mandelbrot
    cr
    maxval minval do
        i dorow cr
  loop ;

\ eeprom.freeze
\ mandelbrot
