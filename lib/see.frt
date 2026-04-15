\ SPDX-License-Identifier: GPL-3.0-only
\ see.frt 
\ A WIP replacement for the old SEE 
\ still very experimental

: bip ( ip -- )
    >r 
    r@ dp0.ram < if
        r@ flash.cell mod 0= if
            [char] . emit space
        else
            space space
        then
    else
        [char] r emit space 
    then
    rdrop
;

: see.header ( xt -- )
    >r
    r@ xt>lfa dup hex. dup bip @ hex. s" LFA" type cr
    r@ xt>ffa dup hex. dup bip @ hex. s" FFA" type cr
    
    r@ xt>nfa dup hex. dup bip @ hex. s" NFA >> " type
    r@ xt>string type s"  <<" type cr 
    r@ dup xt>nfa cell+ ?do
        i hex. i @
        i bip
        hex. cr cell
    +loop
    rdrop 
;    

variable see.xt 
variable see.lfa 
variable see.ip
variable see.done?

: see.ip++ cell see.ip +! ;
: see.line see.ip @ hex. see.ip @ bip see.ip @ @ hex. ; 

: see.do.exit
    see.line
    see.ip @ @ xt>string type space  
    see.ip @
    see.xt @ dup xt>nfa 0> if xt>lfa then 
    - cell + u. s" bytes" type      
    cr
    true see.done? !
;

: see.any? drop true ;

: see.do.lit
    see.line s" L "    type cr see.ip++
    see.line s" <----" type cr see.ip++
;

: see.do.slit
    see.line s" S LITERAL " type cr see.ip++ 
    see.line see.ip @ count type cr                
    see.ip @ c@ 1+ aligned 4 / 1-  
    \ dup s" INDEX " type u. cr 
            
    see.ip++ 
    
    0 ?do see.line s" ..." type cr see.ip++ loop
;

: see.do.xlit
    see.line s" X LITERAL " type cr see.ip++ 
    see.line s" <---- " type  
    see.ip @ @ xt>string type cr 
    see.ip++            
;    

: see.do.compile
    see.line see.ip @ @ xt>string type cr see.ip++
    see.line see.ip @ @ xt>string type cr see.ip++
;    

: see.do.bra 
    see.line s" B "    type cr see.ip++ 
    see.line s" <----" type cr see.ip++ 
; 

: see.do.xt
    see.line
    see.ip @ @ dp.ram dp max < if
        see.ip @ @ xt>string type 
    then
    cr
    see.ip++
;

: see.do.next
    see.line s" NEXT " type
    see.ip @  see.lfa @ - cell + u. s" bytes" type      
    cr
    true see.done? !
;

: see.do.colon see.line s" COLON" type cr see.ip++ ;
: see.do.child see.line s" CHILD" type cr see.ip++ ;
: see.do.codeword see.line s" CODEWORD" type cr see.ip++ ;

: see.colon \# ( xt -- ) SEE: deconstruct a colon word (subword of see)
    dup see.ip ! see.xt ! see.ip @ see.header 
    false see.done? ! 
    see.do.colon
        
    begin
        see.ip @ match
        ['] literal?   act see.do.lit end
        ['] xliteral?  act see.do.xlit end
        ['] sliteral?  act see.do.slit end
        ['] anybranch? act see.do.bra end    
        ['] compile?   act see.do.compile end    
        ['] exit?      act see.do.exit end 
        ['] see.any?   act see.do.xt end 
        endmatch
    see.done? @ until
;

: see.child \# ( xt -- )
    dup see.ip ! see.xt ! see.ip @ see.header
    false see.done? !
    see.do.child 
    begin
        see.ip @ match
            ['] exit?      act see.do.exit end 
            ['] see.any?   act see.line cr see.ip++ end 
        endmatch
    see.done? @ until
    s" --------   --------" type cr 
    see.xt @ @ cell+ cell+ dup see.ip ! see.xt ! false see.done? ! 
    begin
        see.ip @ match
            ['] literal?   act see.do.lit end
            ['] xliteral?  act see.do.xlit end
            ['] sliteral?  act see.do.slit end
            ['] compile?   act see.do.compile end 
            ['] anybranch? act see.do.bra end             
            ['] exit?      act see.do.exit end 
            ['] see.any?   act see.do.xt end 
        endmatch
    see.done? @ until
;

: see.variable ( xt -- )
    dup see.ip ! see.xt ! see.ip @ see.header
    see.line s" VARIABLE" type cr see.ip++
    see.line see.ip @ @ @ dup hex. [char] # emit . cr
;

: see.value ( xt -- )
    dup see.ip ! see.xt ! see.ip @ see.header
    see.line s" VALUE" type cr see.ip++
    see.line see.ip @ @ @ dup hex. [char] # emit . cr
;

: see.defer ( xt -- )
    dup see.ip ! see.xt ! see.ip @ see.header
    see.line s" DEFER" type cr see.ip++
    see.line see.ip @ @ @ dup hex.
    xt>nfa dup 0= if s" NO NFA" else count then
    type cr 
;

: see.constant ( xt -- )
    dup see.ip ! see.xt ! see.ip @ see.header
    see.line s" CONSTANT" type cr see.ip++
    see.line see.ip @ @ [char] # emit . cr
;

: (see) \# ( xt -- ) deconstruct word from XT
    dup >r xt>ffa @ $FFFF and flag.init invert and 
    case
        flag.var   of r> see.variable endof
        flag.colon of r> see.colon endof
        flag.con   of r> see.constant endof
        flag.defer of r> see.defer endof
        flag.value of r> see.value endof
        flag.child of r> see.child endof
        s" flag type " type . s" not supported " type cr
        false
        rdrop 
    endcase
;

: see \# ( "name" ) deconstruct word "name"
    parse-name find-xt if
        (see)
    else
        s" name not found" type cr
    then
;
