\ AmForth32 on QEMU ARM MPS2: four bouncing balls and a gravity interrupt.
\ A self-running demo for a terminal that understands ANSI escapes.
\
\ Run from arm/mcu/qemu (TARGET=MPS2, the default):
\   cat ../../../examples/arm-qemu-irq-bounce.frt | make stdio
\ Quit QEMU with Ctrl-A x. The demo hides the cursor; show it again
\ afterwards with:  printf '\e[?25h'
\
\ The operator and tasks 1, 2 and 3 each bounce their own ball in their
\ own box. Every 6th SysTick interrupt (about 4 s) flips gravity: the
\ handler only changes variables and lights the IRQ lamp, and all four
\ balls react. Needs a terminal of at least 80 x 22.
\
\ Differences from the RISC-V version (examples/rv-qemu-irq-bounce.frt):
\
\ * Timer. SysTick is a 24-bit down counter. warm sets it to the maximum
\   reload ($FFFFFF) with its interrupt enabled, and ms measures time by
\   reading it, so the reload must stay at maximum. At 25 MHz it wraps
\   every 2^24 ticks = 0.671 s; the handler counts wraps and flips gravity
\   on every 6th one (4.03 s). Nothing needs re-arming.
\
\ * The interrupt has no user area of its own. On ARM the handler runs on
\   the user area (and data stack) of whichever task it interrupted. So it
\   must not use anything kept in the user area: no do..loop (loop index
\   and limit), no number output (base), no catch/throw (handler), and no
\   emit or pause. It uses only @ ! +! negate and if.
\
\ * Four actors. TASKN is 4 but task! and +task only accept slots 1 and 2,
\   and the task ring stops at slot 2: the last slot is set aside for an
\   interrupt task. ARM does not use that slot, so slot 3 is set up and
\   linked into the ring by hand here (see task-3!).

single  decimal

12 constant rows      \ inside height of a box
8  constant cols      \ inside width of a box
4  constant actors    \ operator + tasks 1..3
6  constant wraps     \ SysTick wraps per gravity flip: 6 x 0.671 s

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
variable flips   \ gravity flips so far
variable flash   \ frames the IRQ lamp stays lit
variable left#   \ SysTick wraps until the next flip

\ No user-area words in here: see the notes at the top.
: flip-isr ( -- )
  -1 left# +!  left# @ 0= if
    wraps left# !
    grav @ negate grav !  1 flips +!  6 flash !
  then ;i

\ ---- the balls: one record per actor (0 operator, 1..3 tasks)

\ Each ball has its own top speed (bmax) and its actor its own frame
\ delay, from a hot, fast operator ball down to a sluggish task 3 ball.

create balls  actors 6 * cells allot
: ball  ( b -- addr )   6 cells *  balls + ;
: bx    ( b -- addr )   ball ;
: by    ( b -- addr )   ball cell+ ;
: bvx   ( b -- addr )   ball 2 cells + ;
: bvy   ( b -- addr )   ball 3 cells + ;
: bfr   ( b -- addr )   ball 4 cells + ;
: bmax  ( b -- addr )   ball 5 cells + ;

: left    ( b -- col )   cols 6 + *  3 + ;   \ box width plus a gap of 4
: bottom  ( -- row )   rows 4 + ;            \ row of a box's bottom edge
: cell-at ( b x y -- )   4 +  rot left 1+  rot +  at ;

: clamp   ( n b -- n )   bmax @ >r  r@ min  r> negate max ;
: bounce  ( b -- )   dup bvy @ negate  swap bvy ! ;

: step-x ( b -- )
  dup bvx @ over bx @ +                       ( b x' )
  dup 0 cols within 0= if
    drop  dup bvx @ negate over bvx !  dup bvx @ over bx @ +
  then  swap bx ! ;

: step-y ( b -- )
  dup bvy @ grav @ +  over clamp  over bvy !  \ gravity, up to top speed
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
  1 44 at ." IRQ ("
  flash @ if ."  * " -1 flash +! else ."    " then
  ." )  flips " flips @ n.
  2 44 at ." gravity "  grav @ 0> if ." v down" else ." ^ up  " then ;

\ ---- the screen

: hline ( -- )   [char] + emit  cols 0 do [char] - emit loop  [char] + emit ;
: box ( b -- )
  3 over left at hline
  rows 0 do  i 4 + over left at  [char] | emit cols spaces [char] | emit  loop
  bottom over left at hline  drop ;
: label ( b -- )
  bottom 1+ over left 1+ at
  case 0 of ." operator" endof
       1 of ." task 1" endof
       2 of ." task 2" endof
       3 of ." task 3" endof
  endcase ;

: init-ball ( x y vx vmax b -- )
  >r  r@ bmax !  r@ bvx !  r@ by !  r@ bx !  0 r@ bvy !  0 r> bfr ! ;

\ ---- the tasks and the operator (operator 20 ms, see demo)

: task-1 ( -- )   decimal  begin 1 step 50 ms again ;
: task-2 ( -- )   decimal  begin 2 step 120 ms again ;
: task-3 ( -- )   decimal  begin 3 step 250 ms again ;

\ User area fields of task n (offsets from core/user.inc).
: u.link   ( n -- addr )   task@ ;
: u.status ( n -- addr )   task@ cell+ ;
: u.xt     ( n -- addr )   task@ 2 cells + ;

\ Start xt in slot 3, which task! and +task refuse. Call in single mode.
: task-3! ( xt -- )
  3 u.xt !  3 task.warm         \ task.warm accepts slot 3; it sets status 0
  3 task@  2 u.link !           \ ring: operator -> 1 -> 2 -> 3
  0 task@  3 u.link !           \       3 -> operator
  true 3 u.status ! ;

: setup ( -- )
  decimal  cls hide  -1 scr !
  1 grav !  0 flips !  0 flash !  wraps left# !
  1 0  2 4 0 init-ball   6 3 -2 3 1 init-ball   \ x y vx vmax b
  3 6  1 2 2 init-ball   4 9 -1 1 3 init-ball
  actors 0 do i box  i label  i show-ball loop
  1 3 at ." AmForth32 on QEMU MPS2 (Cortex-M4)"
  bottom 4 + 3 at ." Every 6th SysTick interrupt (~4 s) flips gravity. The handler"
  bottom 5 + 3 at ." only changes variables; each actor draws its own ball."
  ['] task-1 1 task!  1 task.warm  1 +task
  ['] task-2 2 task!  2 task.warm  2 +task
  ['] task-3 task-3!
  ['] flip-isr systick# trap!  +int
  multi ;

: demo ( -- )
  setup
  begin  0 step  {scr show-lamp scr}  20 ms  again ;

demo
