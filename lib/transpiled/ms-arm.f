\
\ Using Systick for the default ARM implementation of ms as that is available
\ on any Cortex-M target. May be overridden in specific targets.
\
\ SYSTICK_TICKS_PER_MS is supplied by the MCU configuration and must match
\ the clock selected by systick.init.
: ms ( n -- ) \ delay n milliseconds, calling PAUSE
    systick@
    begin
        \ ( n start )
        over 0= if 2drop exit then
        begin
            \ ( n start )
            pause
            systick@
            over over - \ ( n start end elapsed )
            \ if elapsed is negative due to systick rollover,
            \ adjust it by adding timer's 24-bit period (2^24)     
            dup 0< if $01000000 + then
            \ if elapsed is more than 1 ms leave the loop,
            \ otherwise drop elapsed and end, and loop again
            dup symbol SYSTICK_TICKS_PER_MS > dup not if
                nip nip
            then
        until
        \ ( n start end elapsed )
        \ adjust end with elapsed so that it reflects where 1ms elapsed
        \ end = end + (elapsed - SYSTICK_TICKS_PER_MS)
        symbol SYSTICK_TICKS_PER_MS - +
        \ fix ajdusted end if it exceeds the timer range
        $00ffffff and
        \ end is now the new start and decrement n
        nip swap 1- swap
    again
;