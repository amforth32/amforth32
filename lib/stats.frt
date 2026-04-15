\ display memory stats of the running system
\ shows USED / TOTAL (in bytes) and % used for each memory area
\ shows area start address at the end after @

: stats.line ( start total used -- )
    dup 7 u.r space #47 emit \ emit used
    #100 * swap \ ( start used*100 total )
    dup 7 u.r space #66 emit \ emit total
    / 4 u.r #37 emit \ emit percent used
    2 spaces #64 emit space hex. \ emit start address
;

: stats.flash
    ." FLASH:    "
    flash.low flash.max flash.low -
    memmode if dp else dp.flash then flash.low -
    stats.line cr
;

\ Shows stats for the active PVFLASH arena
\ Append arena number and generation count at the end of the line, e.g. A2: 5
: stats.pvflash
    ." PVFLASH:  "
    pvarena pvarena.size pvp pvarena - 
    stats.line 2 spaces
    #65 emit pvarena pvarena1 = if 49 else 50 then emit \ emit arena number
    pvarena @ $fffffff and \ get generation count
    #58 emit space . \ emit generation
    cr
;

: stats.rampool 
    ." RAM pool: "
    vp0 vp.max vp0 - vp vp0 -
    stats.line
    cr
;

: stats.ramdict 
    ." RAM dict: "
    dp0.ram dp.ram.max dp0.ram -
    memmode if dp.ram else dp then dp0.ram -
    stats.line cr
;

: stats stats.flash stats.pvflash stats.rampool stats.ramdict ;
