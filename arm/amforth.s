# This is a template to start from.
# Copy it into your mcu/ directory and modify as needed.

.globl PFA_COLD 

.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified
.cpu cortex-m4
.thumb

/*
WARNING: Note that it is critical to specify section flags correctly,
otherwise the linker may exclude the section or not allocate space for it.
 
The ALLOC ('a') Flag: The linker maintains a "Location Counter" (the . symbol)
that tracks the current Virtual Memory Address (VMA).
This counter only advances when the linker places a section that is marked as Allocatable (ALLOC).
The default (custom) section flags seem to be CONTENTS and READONLY so not ALLOC
 */
 
.section .vector, "ax"
.include "vectors.s" 

.section amforth, "ax"

STARTDICT

.include "isr.s"
.include "system.s"
.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
