: show.ua ( n -- ) \ show user area task n
    \ drop
    s" OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
    type cr
    32 0 do
        i cells 3 u.r space \ print cell offset
        dup task-block * up@ + ( n -- addr ) \ addr is taskN UA
        i cells + dup hex. @ hex. \ emit i-th UA field address and value
        i 4 * case
        symbol USER_RP0         of s" RP0......... " type endof
        symbol USER_RP          of s" RP.......... " type endof
        symbol USER_SP0         of s" SP0......... " type endof
        symbol USER_SP          of s" SP.......... " type endof
        symbol USER_LP0         of s" LP0......... " type endof
        symbol USER_LP          of s" LP.......... " type endof
        symbol USER_HANDLER     of s" HANDLER..... " type endof
        symbol USER_BASE        of s" BASE........ " type endof
        symbol USER_LOOP_INDEX  of s" LOOP_INDEX.. " type endof
        symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT.. " type endof
        symbol USER_LINK        of s" LINK........ " type endof
        symbol USER_IP          of s" IP.......... " type endof
        symbol USER_TOS         of s" TOS......... " type endof
        symbol USER_STATUS      of s" STATUS...... " type endof
        symbol USER_XT          of s" XT.......... " type endof
        symbol USER_EMIT        of s" EMIT........ " type endof
        s" ............ " type
        endcase
        i 1+ 2 mod 0= if cr then
    loop
    drop
;
