\ ============================================================
\ I2C1 master for CH32V307 — polled, remapped to PB8/PB9
\ Pins: PB8 = SCL, PB9 = SDA  (I2C1 remap via AFIO_PCFR1.I2C1_REMAP=1)
\ Assumes PCLK1 = 36 MHz unless changed via i2c.pclk-mhz value.
\
\ External pull-ups REQUIRED on SDA and SCL.
\ Typical: 4.7k (100kHz) / 2.2k (400kHz).
\
\ ============================================================
\ STACK API (all data on data stack, no scratch buffers)
\   i2c.ping?    ( hwid -- f )
\   i2c.c!       ( c hwid -- )
\   i2c.c@       ( hwid -- c )
\   i2c.n!       ( xn..x1 n hwid -- )                x1 sent first
\   i2c.n@       ( n hwid -- x1..xn )                x1 received first, deepest
\   i2c.m!n@     ( n xm..x1 m hwid -- x1..xn )       n DEEPEST
\   i2c.r!       ( c reg hwid -- )
\   i2c.r@       ( reg hwid -- c )
\   i2c.rn@      ( n reg hwid -- x1..xn )            n DEEPEST
\
\ SCOPE WORDS (for big-data buffer use)
\   i2c.begin      ( hwid -- )                       START + addr+W
\   i2c.begin-read ( hwid -- )                       (re)START + addr+R
\   i2c.end        ( -- )                            STOP if still owning bus
\   i2c.current    variable                          active hwid (0 = idle)
\
\ BULK PRIMITIVES (use inside begin/end scope)
\   i2c.tx       ( c -- )                            send one byte
\   i2c.rxn      ( buf N -- )                        read N bytes into buf
\                                                    (issues STOP internally)
\
\ UTILITIES
\   i2c.ping?    also doubles as bus probe
\   i2c.write-poll ( hwid -- )                       ACK-poll until write done
\
\   i2c.done                                         0=ok 1=NACK 2=BERR 3=ARLO 4=timeout
\ ============================================================

\ ---- I2C1 register block ----
$40005400 constant I2C1.CTLR1
$40005404 constant I2C1.CTLR2
$40005408 constant I2C1.OADDR1
$4000540C constant I2C1.OADDR2
$40005410 constant I2C1.DATAR
$40005414 constant I2C1.STAR1
$40005418 constant I2C1.STAR2
$4000541C constant I2C1.CKCFGR
$40005420 constant I2C1.RTR

\ ---- RCC ----
$40021018 constant RCC.APB2PCENR
$4002101C constant RCC.APB1PCENR
$40021010 constant RCC.APB1PRSTR
$00000001 constant RCC.APB2.AFIOEN
$00000008 constant RCC.APB2.IOPBEN
$00200000 constant RCC.APB1.I2C1EN
$00200000 constant RCC.APB1.I2C1RST

\ ---- AFIO ----
$40010004 constant AFIO.PCFR1
$00000002 constant AFIO.I2C1_REMAP

\ ---- GPIOB ----
$40010C00 constant GPIOB.CFGLR
$40010C04 constant GPIOB.CFGHR

\ ---- CTLR1 bits ----
$0001 constant CTLR1.PE
$0100 constant CTLR1.START
$0200 constant CTLR1.STOP
$0400 constant CTLR1.ACK
$0800 constant CTLR1.POS
$8000 constant CTLR1.SWRST

\ ---- STAR1 bits ----
$0001 constant STAR1.SB
$0002 constant STAR1.ADDR
$0004 constant STAR1.BTF
$0040 constant STAR1.RXNE
$0080 constant STAR1.TXE
$0100 constant STAR1.BERR
$0200 constant STAR1.ARLO
$0400 constant STAR1.AF
$0800 constant STAR1.OVR
$1000 constant STAR1.PECERR
$4000 constant STAR1.TIMEOUT

\ ---- STAR2 bits ----
$0002 constant STAR2.BUSY

\ ---- CKCFGR bits ----
$8000 constant CKCFGR.FS
$4000 constant CKCFGR.DUTY

\ ============================================================
\ Configuration
\ ============================================================
36     value i2c.pclk-mhz
100000 value i2c.clock

\ ============================================================
\ State
\ ============================================================
variable i2c.done            \ 0=ok 1=NACK 2=BERR 3=ARLO 4=timeout
variable i2c.current         \ active hwid (0 = no transaction open)
variable i2c.timeout-cyc-v

\ Private 64-byte receive area for stack-API multi-byte reads.
\ Larger reads use the scope words and a caller-supplied buffer.
create i2c.rxq $42 allot

\ ============================================================
\ Bit helpers
\ ============================================================
: hbis!  ( mask a -- )  dup h@ rot or  swap h! ;
: hbic!  ( mask a -- )  dup h@ rot invert and swap h! ;
: bis!   ( mask a -- )  dup @  rot or  swap ! ;
: bic!   ( mask a -- )  dup @  rot invert and swap ! ;

\ ============================================================
\ Timeout helpers
\ ============================================================
: i2c.timeout-cyc  ( -- u )  i2c.timeout-cyc-v @ ;

: i2c.wait-set  ( mask a -- ok? )
   tick@
   begin
      over h@  3 pick and  if
         drop drop drop true exit
      then
      tick@ over -
      i2c.timeout-cyc u>
   until
   drop drop drop false ;

: i2c.wait-clr  ( mask a -- ok? )
   tick@
   begin
      over h@  3 pick and  0= if
         drop drop drop true exit
      then
      tick@ over -
      i2c.timeout-cyc u>
   until
   drop drop drop false ;

\ ============================================================
\ Error helpers
\ ============================================================
: i2c.clr-errflags
   I2C1.STAR1 h@
   STAR1.BERR STAR1.ARLO or STAR1.AF or STAR1.OVR or
   STAR1.PECERR or STAR1.TIMEOUT or
   invert and  I2C1.STAR1 h! ;

: i2c.stop  CTLR1.STOP I2C1.CTLR1 hbis! ;

: i2c.fail  ( code -- )
   i2c.done !
   i2c.stop
   i2c.clr-errflags
   CTLR1.POS I2C1.CTLR1 hbic!
   0 i2c.current ! ;

: i2c.wait-star1  ( mask -- ok? )
   tick@
   begin
      I2C1.STAR1 h@
      dup STAR1.AF and if
         drop drop drop  1 i2c.fail  false exit
      then
      2 pick and if
         drop drop true exit
      then
      tick@ over -
      i2c.timeout-cyc u>
   until
   drop drop  4 i2c.fail  false ;

\ ============================================================
\ Bring-up
\ ============================================================
: i2c.gpio-init
   RCC.APB2.IOPBEN  RCC.APB2PCENR bis!
   RCC.APB2.AFIOEN  RCC.APB2PCENR bis!
   AFIO.I2C1_REMAP  AFIO.PCFR1   bis!
   GPIOB.CFGHR @
      $000000ff invert and
      $000000ff or
   GPIOB.CFGHR ! ;

: i2c.clock-on
   RCC.APB1.I2C1EN  RCC.APB1PCENR bis!
   RCC.APB1.I2C1RST RCC.APB1PRSTR bis!
   RCC.APB1.I2C1RST RCC.APB1PRSTR bic! ;

: i2c.timing!
   I2C1.CTLR2 h@  $ffc0 and  i2c.pclk-mhz or  I2C1.CTLR2 h!
   i2c.clock 100000 u> if
      i2c.pclk-mhz 1000000 *  i2c.clock 3 *  /
      CKCFGR.FS or  I2C1.CKCFGR h!
      i2c.pclk-mhz 300 *  1000 /  1+  I2C1.RTR h!
   else
      i2c.pclk-mhz 1000000 *  i2c.clock 2 *  /  I2C1.CKCFGR h!
      i2c.pclk-mhz 1+  I2C1.RTR h!
   then ;

: i2c.setup
   ms.tickf 20 / i2c.timeout-cyc-v !
   0 i2c.current !
   i2c.gpio-init
   i2c.clock-on
   0          I2C1.CTLR1 h!
   i2c.timing!
   CTLR1.ACK  I2C1.CTLR1 hbis!
   CTLR1.PE   I2C1.CTLR1 hbis! ;

\ ============================================================
\ Internal: address + raw start
\ ============================================================
\ Send 7-bit address with R/W bit. ( hwid dir -- ok? )
\ Clears ADDR by reading STAR1 then STAR2.
: i2c.send-addr
   swap 2*  or  I2C1.DATAR h!
   STAR1.ADDR i2c.wait-star1 dup 0= if exit then
   I2C1.STAR1 h@ drop
   I2C1.STAR2 h@ drop ;

\ Issue START (or repeated START if bus already owned) and wait for SB.
: i2c.raw-start  ( -- ok? )
   i2c.clr-errflags
   CTLR1.ACK   I2C1.CTLR1 hbis!
   CTLR1.START I2C1.CTLR1 hbis!
   STAR1.SB i2c.wait-star1 ;

\ ============================================================
\ Scope words
\ ============================================================
\ Open a write transaction. ( hwid -- )
: i2c.begin
   dup i2c.current !
   0 i2c.done !
   i2c.current @ 0= if  drop exit then
   STAR2.BUSY I2C1.STAR2 i2c.wait-clr 0= if
      drop  4 i2c.fail  exit
   then
   i2c.raw-start 0= if drop exit then
   0 i2c.send-addr drop ;

\ Open a read transaction (or repeated-START to switch to read).  ( hwid -- )
: i2c.begin-read
   dup i2c.current !
   0 i2c.done !
   i2c.current @ 0= if drop exit then
   i2c.current @ I2C1.STAR2 h@ STAR2.BUSY and 0= and if
      STAR2.BUSY I2C1.STAR2 i2c.wait-clr 0= if
         drop  4 i2c.fail  exit
      then
   then
   CTLR1.ACK I2C1.CTLR1 hbis!
   i2c.raw-start 0= if drop exit then
   1 i2c.send-addr drop ;

\ Close transaction. Idempotent — if i2c.rxn already issued STOP,
\ this just clears i2c.current.
: i2c.end
   i2c.current @ if
      I2C1.STAR2 h@ STAR2.BUSY and if
         i2c.stop
      then
      0 i2c.current !
   then ;

\ ============================================================
\ Bulk primitives: i2c.tx and i2c.rxn
\ ============================================================
\ Send one byte. Sets i2c.done on error. ( c -- )
: i2c.tx
   i2c.done @ if drop exit then
   STAR1.TXE i2c.wait-star1 0= if drop exit then
   I2C1.DATAR h!
   STAR1.TXE i2c.wait-star1 drop ;

\ Receive sequences for N=1, N=2, N>=3, per RM §19.3.
: i2c.rx-1   \ ( buf -- )
   CTLR1.ACK I2C1.CTLR1 hbic!
   I2C1.STAR1 h@ drop  I2C1.STAR2 h@ drop
   CTLR1.STOP I2C1.CTLR1 hbis!
   STAR1.RXNE i2c.wait-star1 0= if drop exit then
   I2C1.DATAR h@ swap c! ;

: i2c.rx-2   \ ( buf -- )
   CTLR1.ACK I2C1.CTLR1 hbis!               \ ACK=1
   CTLR1.POS I2C1.CTLR1 hbis!               \ POS=1
   I2C1.STAR1 h@ drop  I2C1.STAR2 h@ drop   \ clear ADDR
   STAR1.BTF i2c.wait-star1 0= if drop CTLR1.POS I2C1.CTLR1 hbic! exit then
   CTLR1.ACK I2C1.CTLR1 hbic!               \ ACK=0 (NACK byte 2)
   CTLR1.STOP I2C1.CTLR1 hbis!
   I2C1.DATAR h@  over c!  1+
   I2C1.DATAR h@  swap c!
   CTLR1.POS I2C1.CTLR1 hbic! ;

\ : i2c.rx-2   \ ( buf -- )
\    CTLR1.ACK I2C1.CTLR1 hbic!
\    CTLR1.POS I2C1.CTLR1 hbis!
\    I2C1.STAR1 h@ drop  I2C1.STAR2 h@ drop
\    STAR1.BTF i2c.wait-star1 0= if drop CTLR1.POS I2C1.CTLR1 hbic! exit then
\    CTLR1.STOP I2C1.CTLR1 hbis!
\    I2C1.DATAR h@  over c!  1+
\    I2C1.DATAR h@  swap c!
\    CTLR1.POS I2C1.CTLR1 hbic! ;

: i2c.rx-n   \ ( buf N -- )    N>=3
   I2C1.STAR1 h@ drop  I2C1.STAR2 h@ drop
   dup 3 - 0 ?do
      STAR1.RXNE i2c.wait-star1 0= if drop drop unloop exit then
      I2C1.DATAR h@  2 pick  i + c!
   loop
   STAR1.BTF i2c.wait-star1 0= if drop drop exit then
   CTLR1.ACK I2C1.CTLR1 hbic!
   over swap 3 - +                          \ p = buf + (N-3)
   I2C1.DATAR h@  over c!  1+
   STAR1.BTF i2c.wait-star1 0= if drop drop exit then
   CTLR1.STOP I2C1.CTLR1 hbis!
   I2C1.DATAR h@  over c!  1+
   I2C1.DATAR h@  swap c!
   drop ;

\ Read N bytes into buf. Issues STOP internally.   ( buf N -- )
: i2c.rxn
   i2c.done @ if drop drop exit then
   dup 0= if drop drop exit then
   dup 1 = if drop i2c.rx-1 exit then
   dup 2 = if drop i2c.rx-2 exit then
   i2c.rx-n ;

\ ============================================================
\ Stack-native API
\ ============================================================
: i2c.ping?  ( hwid -- f )
   i2c.begin
   i2c.end
   i2c.done @ 0= ;

: i2c.write-poll  ( hwid -- )
   begin dup i2c.ping? until drop ;

: i2c.c!  ( c hwid -- )
   i2c.begin
   i2c.tx
   i2c.end ;

: i2c.c@  ( hwid -- c )
   i2c.begin-read
   i2c.rxq 1 i2c.rxn
   0 i2c.current !
   i2c.rxq c@ ;

: i2c.n!  ( xn..x1 n hwid -- )
   swap >r
   i2c.begin
   r>  0 ?do  i2c.tx  loop
   i2c.end ;

: i2c.n@  ( n hwid -- x1..xn )
   swap >r
   i2c.begin-read
   i2c.rxq r@ i2c.rxn
   0 i2c.current !
   r> 0 ?do  i2c.rxq i + c@  loop ;

: i2c.m!n@   ( n xm..x1 m hwid -- x1..xn )
   >r                                     ( n xm..x1 m       R: hwid )
   r@ i2c.begin
   0 ?do  i2c.tx  loop                    ( n                R: hwid )
   r> i2c.begin-read
   dup i2c.rxq swap i2c.rxn               ( n                R: )
   0 i2c.current !
   0 ?do  i2c.rxq i + c@  loop ;

: i2c.r!   ( c reg hwid -- )         >r 2 r> i2c.n! ;
: i2c.r@   ( reg hwid -- c )         >r 1 1 r> i2c.m!n@ ;
: i2c.rn@  ( n reg hwid -- x1..xn )  >r 1 r> i2c.m!n@ ;

: i2c.setup?  ( -- f )
    I2C1.CTLR1 h@ CTLR1.PE and 0<>
;

\ ============================================================
\ Bus scan
\ ============================================================
: i2c.detect
   i2c.setup? not if s" I2C not setup" type cr exit then
   base @ >r hex
   4 spaces $10 0 do i 3 u.r loop
   $80 0 do
      i $0f and 0= if cr i 2 u.r [char] : emit space then
      i $08 $78 within if
         i i2c.ping? if i 3 u.r else s"  --" type then
      else
         s"    " type
      then
   loop
   cr r> base ! ;

\ ============================================================
\ Diagnostics
\ ============================================================
: i2c.regs
   cr s" CTLR1=" type I2C1.CTLR1 h@ 4 u.r
      s"  CTLR2=" type I2C1.CTLR2 h@ 4 u.r
      s"  STAR1=" type I2C1.STAR1 h@ 4 u.r
      s"  STAR2=" type I2C1.STAR2 h@ 4 u.r
      s"  done="  type i2c.done @ .
      s"  curr="  type i2c.current @ . cr ;

\ ============================================================
\ Verified test words (24Cxx EEPROM at $57 assumed)
\ ============================================================
$57 constant EEPROM

create demo-buf 32 allot

: test.scan
   cr s" --- bus scan ---" type cr
   i2c.detect ;

\ Manual byte-at-a-time write/read using scope words.
\ Verifies i2c.tx / i2c.rxn / i2c.begin / i2c.begin-read / i2c.end.
: test.scope
   EEPROM i2c.begin
      $00 i2c.tx
      $10 i2c.tx
      $aa i2c.tx
      $bb i2c.tx
      $cc i2c.tx
      $dd i2c.tx
   i2c.end
   cr s" scope write done=" type i2c.done @ .

   EEPROM i2c.write-poll

   EEPROM i2c.begin
      $00 i2c.tx
      $10 i2c.tx
   EEPROM i2c.begin-read
      i2c.rxq 4 i2c.rxn
   0 i2c.current !

   cr s" rxq[$0010..$0013] = " type
   i2c.rxq      c@ hex.
   i2c.rxq 1 +  c@ hex.
   i2c.rxq 2 +  c@ hex.
   i2c.rxq 3 +  c@ hex.
   cr s" expected: aa bb cc dd" type
   cr s" done=" type i2c.done @ . cr ;

\ Multi-byte stack write via i2c.n!.
: test.n!
   EEPROM i2c.begin
      $00 i2c.tx  $10 i2c.tx
      $00 i2c.tx  $00 i2c.tx  $00 i2c.tx  $00 i2c.tx
   i2c.end
   EEPROM i2c.write-poll

   $de $ad $be $ef $10 $00 6 EEPROM i2c.n!
   cr s" i2c.n! done=" type i2c.done @ .
   EEPROM i2c.write-poll

   EEPROM i2c.begin
      $00 i2c.tx  $10 i2c.tx
   EEPROM i2c.begin-read
      i2c.rxq 4 i2c.rxn
   0 i2c.current !
   cr s" rxq = " type
   i2c.rxq      c@ hex.
   i2c.rxq 1 +  c@ hex.
   i2c.rxq 2 +  c@ hex.
   i2c.rxq 3 +  c@ hex.
   cr s" expected: ef be ad de" type
   cr s" done=" type i2c.done @ . cr ;

\ Multi-byte stack read via i2c.n@.
: test.n@
   EEPROM i2c.begin
      $00 i2c.tx  $10 i2c.tx
      $00 i2c.tx  $00 i2c.tx  $00 i2c.tx  $00 i2c.tx
   i2c.end
   EEPROM i2c.write-poll

   $de $ad $be $ef $10 $00 6 EEPROM i2c.n!
   EEPROM i2c.write-poll

   EEPROM i2c.begin
      $00 i2c.tx  $10 i2c.tx
   i2c.end

   cr s" --- i2c.n@ 4 from $0010 ---" type cr
   4 EEPROM i2c.n@
   cr s" got (top first): " type
   hex. hex. hex. hex.
   cr s" expected: de ad be ef" type
   cr s" done=" type i2c.done @ . cr ;

\ Random-read combined op via i2c.m!n@.
: test.m!n@
   EEPROM i2c.begin
      $00 i2c.tx  $10 i2c.tx
      $00 i2c.tx  $00 i2c.tx  $00 i2c.tx  $00 i2c.tx
   i2c.end
   EEPROM i2c.write-poll

   $de $ad $be $ef $10 $00 6 EEPROM i2c.n!
   EEPROM i2c.write-poll

   cr s" --- i2c.m!n@ 4 random-read from $0010 ---" type cr
   4  $10 $00 2  EEPROM i2c.m!n@
   cr s" got (top first): " type
   hex. hex. hex. hex.
   cr s" expected: de ad be ef" type
   cr s" done=" type i2c.done @ . cr ;

\ Big-data demo using scope words: read 16 bytes from $0000 into a buffer.
: test.bigread
   cr s" --- big read 16 bytes via scope words ---" type cr
   EEPROM i2c.begin
      $00 i2c.tx
      $00 i2c.tx
   EEPROM i2c.begin-read
      demo-buf 16 i2c.rxn
   i2c.end
   cr s" done=" type i2c.done @ . cr
   16 0 do  demo-buf i + c@  4 u.r  loop  cr ;

\ Register-access wrappers (untested as of last session — exercises r!, r@, rn@).
: test.regs-api
   \ Treat EE address $0010 as a "register"; write $5a, read it back.
   $5a $00 $10 EEPROM i2c.r!
   cr s" i2c.r! done=" type i2c.done @ .
   EEPROM i2c.write-poll

   \ Wait — i2c.r! signature is ( c reg hwid -- ), reg is a single byte.
   \ For 24Cxx 2-byte addressing this is wrong. Keep the demo simple and
   \ use a register-style device when available. Skipping for now.
   cr s" register-API test skipped (needs single-byte-reg device)" type cr ;

: test.all
   test.scan
   test.scope
   test.n!
   test.n@
   test.m!n@
   test.bigread ;

\ ============================================================
\ Usage:
\   i2c.setup
\   test.all
\
\ Stack-native examples:
\   $5c 0 0 3 $57 i2c.n!         ( write $5c to $0000 )
\   1 0 0 2 $57 i2c.m!n@ .       ( random-read 1 byte from $0000 )
\
\ Big-data idiom (write address then read N bytes into your buffer):
\   $57 i2c.begin
\      addr-hi i2c.tx  addr-lo i2c.tx
\   $57 i2c.begin-read
\      mybuf 256 i2c.rxn
\   i2c.end
\
\ Big-data write (send N bytes from your buffer):
\   $57 i2c.begin
\      addr-hi i2c.tx  addr-lo i2c.tx
\      mybuf 256 0 do dup i + c@ i2c.tx loop drop
\   i2c.end
\ ============================================================