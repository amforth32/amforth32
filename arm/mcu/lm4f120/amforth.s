
.global PFA_COLD 

.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "ax"
.include "vectors.s"

.section amforth, "ax"

STARTDICT

.include "isr.s"
.include "system-m.s"

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
