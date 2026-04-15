# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "board", BOARD /* ( -- addr u ) string with board identifier */
    STRING "QEMU"
    .word XT_EXIT
END BOARD
