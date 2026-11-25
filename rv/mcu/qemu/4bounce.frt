\ AmForth32 on QEMU RISC-V: four bouncing balls and a gravity interrupt.
\ A self-running demo for a terminal that understands ANSI escapes.
\
\ Run from rv/mcu/qemu:
\   cat ../../../examples/rv-qemu-irq-bounce.frt | make stdio
\ Quit QEMU with Ctrl-A x. The demo hides the cursor; show it again
\ afterwards with:  printf '\e[?25h'
\
\ The operator, task 1, task 2 and task 3 each bounce their own ball in
\ their own box. Every 4 seconds a timer interrupt flips gravity: the
\ handler only changes a variable and lights the IRQ lamp, and all four
\ balls react. Needs a terminal of at least 80 x 22, and a build with
\ taskn >= 4 (operator + 3 tasks).

single  decimal

12 constant rows      \ inside height of a box
8  constant cols      \ inside width of a box
40000000 constant period   \ timer ticks between flips: 4 s at 10 MHz

\ ---- terminal output (ANSI escapes)

: esc   ( -- )   27 emit [char] [ emit ;
: n.    ( u -- )   0 <# #s #> type ;
: n.r   ( u w -- )   >r 0 <# #s #> r> over - spaces type ;
: at    ( row col -- )   esc swap n. [char] ; emit n. [char] H emit ;
: cls   ( -- )   esc s" 2J" type ;
: hide  ( -- )   esc s" ?25l" type ;

\ emit calls pause, so whoever draws holds the screen until done.
variable scr
: {scr  ( -- )   scr reserve ;
: scr}  ( -- )   scr release ;

\ ---- state changed by the interrupt handler

variable grav    \ +1 pulls down, -1 pulls up
variable flips   \ timer interrupts taken
variable flash   \ frames the IRQ lamp stays lit
variable nxt-lo  variable nxt-hi   \ next 64-bit timer deadline

\ ---- timer: re-armed from the last deadline, so it does not drift

: mtime64 ( -- d )   mtime @  mtime cell+ @ ;
: cmp!    ( d -- )   -1 mtimecmp !  mtimecmp cell+ !  mtimecmp ! ;
: nxt@    ( -- d )   nxt-lo @  nxt-hi @ ;
: nxt!    ( d -- )   nxt-hi !  nxt-lo ! ;
: rearm   ( -- )
  nxt@ period 0 d+
  2dup mtime64 d- d0< if 2drop mtime64 period 0 d+ then   \ missed: resync
  2dup nxt! cmp! ;

: flip-isr   grav @ negate grav !  1 flips +!  6 flash !  rearm ;i

\ ---- the balls: one record per actor (0 operator, 1-3 tasks 1-3)

create balls  20 cells allot
: ball  ( b -- addr )   5 cells *  balls + ;
: bx    ( b -- addr )   ball ;
: by    ( b -- addr )   ball cell+ ;
: bvx   ( b -- addr )   ball 2 cells + ;
: bvy   ( b -- addr )   ball 3 cells + ;
: bfr   ( b -- addr )   ball 4 cells + ;

: left    ( b -- col )   cols 6 + *  3 + ;   \ box width plus a gap of 4
: bottom  ( -- row )   rows 4 + ;            \ row of a box's bottom edge
: cell-at ( b x y -- )   4 +  rot left 1+  rot +  at ;

: clamp   ( n -- n )   -3 max  3 min ;
: bounce  ( b -- )   dup bvy @ negate  swap bvy ! ;

: step-x ( b -- )
  dup bvx @ over bx @ +                       ( b x' )
  dup 0 cols within 0= if
    drop  dup bvx @ negate over bvx !  dup bvx @ over bx @ +
  then  swap bx ! ;

: step-y ( b -- )
  dup bvy @ grav @ + clamp  over bvy !        \ gravity
  dup by @ over bvy @ +                       ( b y' )
  dup 0 < if drop 0 over bounce then
  dup rows 1- > if drop rows 1- over bounce then
  swap by ! ;

: show-ball ( b -- )   dup dup bx @ swap by @ cell-at [char] o emit ;
: hide-ball ( b -- )   dup dup bx @ swap by @ cell-at space ;

: show-frames ( b -- )   bottom 2 + over left at  bfr @ 6 n.r ."  frames" ;

: step ( b -- )   \ one animation frame of ball b
  {scr  dup hide-ball  dup step-x  dup step-y  dup show-ball
        1 over bfr +!  show-frames  scr} ;

\ ---- the IRQ lamp, drawn by the operator

: show-lamp ( -- )
  1 50 at ." IRQ ("
  flash @ if ."  * " -1 flash +! else ."    " then
  ." )  flips " flips @ n.
  2 50 at ." gravity "  grav @ 0> if ." v down" else ." ^ up  " then ;

\ ---- the screen

: hline ( -- )   [char] + emit  cols 0 do [char] - emit loop  [char] + emit ;
: box ( b -- )
  3 over left at hline
  rows 0 do  i 4 + over left at  [char] | emit cols spaces [char] | emit  loop
  bottom over left at hline  drop ;
: label ( b -- )
  bottom 1+ over left 1+ at
  case 0 of ." operator" endof 1 of ." task 1" endof 2 of ." task 2" endof
       3 of ." task 3" endof endcase ;

: init-ball ( x y vx b -- )
  >r  r@ bvx !  r@ by !  r@ bx !  0 r@ bvy !  0 r> bfr ! ;

\ ---- the tasks and the operator

: task-1 ( -- )   decimal  begin 1 step 80 ms again ;
: task-2 ( -- )   decimal  begin 2 step 110 ms again ;
: task-3 ( -- )   decimal  begin 3 step 140 ms again ;

: setup ( -- )
    taskn 4 < abort" needs taskn >= 4: rebuild with more task slots"
    decimal  cls
    hide
    -1 scr !
  1 grav !  0 flips !  0 flash !
  1 0 1 0 init-ball   6 3 -1 1 init-ball   3 6 1 2 init-ball   \ x y vx b
  5 9 -1 3 init-ball
  4 0 do i box  i label  i show-ball loop
  1 3 at ." AmForth32 on QEMU RISC-V"
  bottom 4 + 3 at ." Every 4 s a timer interrupt flips gravity. The handler only"
  bottom 5 + 3 at ." changes a variable; each actor draws its own ball."
  ['] flip-isr 7 trap!
  mtime64 period 0 d+  2dup nxt! cmp!  7 irq.on  +int
  ['] task-1 1 task!  1 task.warm  1 +task
  ['] task-2 2 task!  2 task.warm  2 +task
  ['] task-3 3 task!  3 task.warm  3 +task
  multi
;

: demo ( -- )
  setup
  begin  0 step  {scr show-lamp scr}  55 ms  again ;
;

demo
