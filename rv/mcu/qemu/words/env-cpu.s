# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "cpu", CPU /* ( -- addr u ) string with cpu identifier */
       STRING "RV32IMAFC"
       .word XT_EXIT
END CPU

ENVIRONMENT "build-type", BUILD_TYPE
       STRING "ASM"
      .word XT_EXIT
END BUILD_TYPE
