\ This is the driver file for running tests on QEMU.
\ This file is passed through CPP which writes the
\ actual test file to the build directory of the mcu being tested.
\ CPP directive include will accept quoted arguments only.

\ the tester itself
#include "tests/tester.frt"

s" TESTS STARTING" type cr

\ The files that contain the tests.
#include "tests/cpp-core.fr"
#include "tests/core2.fr"
#include "tests/pvalue.fr"

\ Do not remove as required by awk processing script
s" TESTS FINISHED" type cr