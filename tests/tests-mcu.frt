\ tests/tests-mcu.frt

\ This is the driver file for running tests on development
\ boards. This file is passed through CPP which writes the
\ actual test file to the build directory of the mcu being
\ tested.

\ WARNING: some of the tests can run destructive operations,
\ so don't run against real MCUs without reviewing the tests.
    
\ CPP directive include will accept quoted arguements
\ but not unquoted ones. amforth-shell will accept both. 
\ Remember to quote the included files in this file and
\ any files that are included by files in this file...

\ >ram
>flash

\ amforth-shell requires a modified tester 
#include "tests/tester-mcu.frt"

\ output hardware and build information
s" TYPE DP " type dp hex. cr 
hardware

\ The files that contain the tests. To comment out a
\ test file so that amforth-shell won't see it remember
\ to remove the # as well. 

#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"

\ Do not remove as required by awk processing script

s" TESTS FINISHED" type cr

\ Do not uncomment the #exit or CPP will complain
\ amforth-shell (with defaults) will still see it 
\ #exit

\ what follows repeats the tests a further 15  times
\ but at a one cell offset starting position. Remove 
\ the hash from the exit above and these tests will
\ be run. This uses a lot of flash and takes a long time.
\ run with caution.

100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
100 , memmode . cr show gd5
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
100 , memmode . cr show gd5
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
100 , memmode . cr show gd5
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
100 , memmode . cr show gd5
s" TYPE DP " type dp hex. cr 
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"
s" TYPE DP " type dp hex. cr 
100 , memmode . cr show gd5
#include "tests/cpp-core-mcu.fr"
#include "tests/core2.fr"


\ Below is used by the results processing awk
\ script so do not remove.     
s" TESTS FINISHED" type cr
\ Do not uncomment the #exit or CPP will complain
\ amforth-shell (with defaults) will still see it 
\ #exit

