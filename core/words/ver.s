# SPDX-License-Identifier: GPL-3.0-only

COLON ".ver", DOT_VER /* ( -- ) show amforth version */
    .word XT_ENV_FORTHNAME, XT_TYPE, XT_SPACE

    .word XT_BASE, XT_FETCH
    .word XT_ENV_FORTHVERSION, XT_DECIMAL, XT_S2D
    .word XT_L_SHARP, XT_SHARP
    .word XT_DOLITERAL, '.'
    .word XT_HOLD, XT_SHARP_S, XT_SHARP_G
    .word XT_TYPE
    .word XT_BASE, XT_STORE

    .word XT_SPACE, XT_ENV_CPU, XT_TYPE
    .word XT_EXIT
END DOT_VER
