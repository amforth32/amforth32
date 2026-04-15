: empty.ram \# ( -- ) empty the RAM dictionary
    0 is ram-wordlist
    memmode if
        dp0.ram is dp.ram
    else
        dp0.ram is dp 
    then
;

: empty.flash \# ( -- ) empty the flash dictionary
    core-wordlist is forth-wordlist
    vp0 is vp
    dp0.flash flash.erase
    memmode if
        dp0.flash is dp
    else
        dp0.flash is dp.flash
    then
;

    

    
