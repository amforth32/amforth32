: ?ip \# ( a -- f ) is a likely to be a valid IP address
\# i.e. is it within the address ranges where words are compiled
    dup flash.low memmode if dp else dp.flash then within if
        drop true
    else
        dp0.ram memmode if dp.ram else dp then within
    then
;

: ip2xt \# ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells)
    dup ?ip not if false exit then \# leave a as is if not an IP address
    #100 0 do ( a ) \# don't go more than 100 cells back
        dup colon? if ( xt )
            i true
            unloop exit
        then ( a )
        cell-
    loop ( a )
    false
;

: ip2name \# ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells)
    ip2xt if ( xt u )
        swap dup xt>nfa ?dup if ( u xt nfa )
            dup @ 3 = if ( u xt nfa )
                drop false \# noname, return xt
            else ( u xt nfa )
                nip nfa>string true
            then
        else ( u xt ) \# nfa not found
            false
        then
    else ( a ) \# xt not found
        0 swap false
    then
;

: .ip \# ( a -- ) print ip as xt+offset
    ip2name \ ( u s true | u a false ) 
    if type
    else over if 8x. else uhex. then
    then \ ( u )
    ?dup if #43 emit dec. then
;

\ The backtrace always omits the top two frames which are .bt and the word that call it,
\ usually debugger or execute. The skip `u` is counted from there.
: .bt \# ( u -- ) print return stack (top first) skipping top u cells, use word names
    rdepth over - dup 0 <= if 2drop exit then ( u depth )
    swap cells rp@ + swap 0 ?do dup @ .ip cell+ loop
    drop
;

: .rs \# ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses
    rdepth over - dup 0 <= if 2drop exit then ( u depth )
    swap cells rp@ + swap 0 ?do dup @ . cell+ loop
    drop
;

: .itc \# ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack
    rdepth over - 0 <= if 2drop drop exit then
    cells rp@ + @ ( u1 ip ) \# get the IP
    swap 0 ?do ( ip )
        s" |D " type dup 8x. space dup @ dup 8x. space xt>string type
        i 0= if s"    <<(IP)<<" type then
        cr cell+
    loop
    drop
;
