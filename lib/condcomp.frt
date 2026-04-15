\ # SPDX-License-Identifier: GPL-3.0-only

: parse-next  ( -- addr len )
  begin
    parse-name dup 0> if exit then
    2drop refill drop
  again
;

: skip-if-block  ( -- )
  1 >r
  begin
    parse-next
    2dup s" [if]"   compare 0= if 2drop r> 1+ >r then
    2dup s" [then]" compare 0= if 2drop r> 1- dup >r 0= if rdrop exit then then
    2dup s" [else]" compare 0= if 2drop r@ 1 = if rdrop exit then then
    2drop
  again
;

: [then]   ; immediate
: [else]   skip-if-block ; immediate
: [if]     0= if skip-if-block then ; immediate

\ body of [if]....[then] may be multiline
\ but some extra directives are needed for
\ amforth-shell to handle 

\ #timeout 0.1
\ #ignore-error YES

true [if]
    : car
        1+
    ;
[else]
    : car
        2+
    ;
[then]

false [if]
    : cat
        dup + 
    ;
[else]
    : cat
        dup * 
    ;
[then]

\ #timeout 10
\ #ignore-error NO

create [do]-stack 32 cells allot
variable [do]-sp  0 [do]-sp !

: [do]-push   ( n -- )   [do]-sp @ cells [do]-stack + !   [do]-sp @ 1+ [do]-sp ! ;
: [do]-pop    ( -- n )   [do]-sp @ 1- dup [do]-sp ! cells [do]-stack + @ ;

: [do]   ( limit index -- )
  [do]-push        \ index -> slot n
  [do]-push        \ limit -> slot n+1
  >in @ [do]-push  \ >in  -> slot n+2
; immediate

: [loop]
  \ increment index
  [do]-sp @ 3 - cells [do]-stack + dup @ 1+ swap !
  \ test index < limit
  [do]-sp @ 3 - cells [do]-stack + @
  [do]-sp @ 2 - cells [do]-stack + @
  < if
    [do]-sp @ 1- cells [do]-stack + @ >in !
  else
    [do]-pop drop
    [do]-pop drop
    [do]-pop drop
  then
; immediate

: [+loop]  ( step -- )
  [do]-sp @ 3 - cells [do]-stack + dup @ rot + swap !
  [do]-sp @ 3 - cells [do]-stack + @
  [do]-sp @ 2 - cells [do]-stack + @
  < if
    [do]-sp @ 1- cells [do]-stack + @ >in !
  else
    [do]-pop drop
    [do]-pop drop
    [do]-pop drop
  then
; immediate

: [i]   [do]-sp @ 3 - cells [do]-stack + @ ; immediate
: [j]   [do]-sp @ 6 - cells [do]-stack + @ ; immediate

\ entire [do]....[loop] must be on one line

\ test non-nested
5 0 [do] [i] . [loop]

\ test nested
3 0 [do] 4 0 [do] [j] [i] * . [loop] [loop]

: prime? ( n -- flag )
  dup 2 < if drop false exit then
  dup 2 = if drop true exit then
  dup 2 mod 0 = if drop false exit then
  3
  begin
    2dup dup * >=
  while
    2dup mod 0 = if 2drop false exit then
    2 +
  repeat
  2drop true
;


create table.prime
#256 0 [do] [i] prime? [if] [i] [else] -1 [then] c, [loop]
table.prime #16 dump


