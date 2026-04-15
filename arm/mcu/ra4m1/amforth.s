
.globl PFA_COLD 

.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "ax"
.include "mcu/ra4m1/vectors.s"

.section amres, "ax"
.include "mcu/ra4m1/words/flash.k"

.p2align 2

.section amforth, "ax"

STARTDICT

.include "isr.s"
.include "system.s"
.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
