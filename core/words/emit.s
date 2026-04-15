# SPDX-License-Identifier: GPL-3.0-only
DEFER "emit", EMIT, XT_SERIAL_EMIT_PAUSE /* ( c -- ) emit single character, pause until able */
END EMIT

COLON "serial-emit-pause" , SERIAL_EMIT_PAUSE /* ( c -- ) emit c on serial connection, pause until able */
    .word XT_PAUSE,XT_SERIAL_EMITQ, XT_DOCONDBRANCH, PFA_SERIAL_EMIT_PAUSE
    .word XT_SERIAL_EMIT
    .word XT_EXIT
END SERIAL_EMIT_PAUSE
