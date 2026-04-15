
/*
    QEMU -M virt emulates Cortex-A CPUs and starts in ARM mode (even for 32-bit CPUs)
    We need to add an entrypoint wrapper that will switch it to Thumb mode before entering PFA_COLD.
*/
.section .text, "ax"
.arm  /* Switch to ARM mode for this part */
.global _start
_start:
    ldr r0, =PFA_COLD
    bx r0

.syntax unified
.cpu cortex-m4
.thumb /* Switch to Thumb mode */

.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.section .vector, "ax"
.include "vectors.s"

.section amforth, "ax"
.include "isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
