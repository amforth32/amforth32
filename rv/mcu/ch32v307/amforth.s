# SPDX-License-Identifier: GPL-3.0-only
# amforth.S 

.globl PFA_COLD 

# startup ----------------------------------------------------------------------

# this is placed in section .init but is included here are values from config.inc
# are needed by both C and AmForth-RV 

.include "mcu/ch32v307/config.inc"   # most configuration options are in this file
.include "build-config.inc"

.ifdef TARGET_203
.print "INFO: using 203 startup"	
.include "203.startup"  # startup and master_int handler for both C and Forth
.endif

.ifdef TARGET_305
.print "INFO: using 307 startup for 305"		
.include "307.startup"  # startup and master_int handler for both C and Forth
.endif 

.ifdef TARGET_307
.print "INFO: using 307 startup"		
.include "307.startup"  # startup and master_int handler for both C and Forth
.endif 

.include "main.s"

# amforth --------------------------------------------

.section amforth,"ax"

.option push                # save option set 
.option norvc               # don't use compressed
.option norelax             # don't relax

.include "rv/macros.inc"       # macros for everything
.include "user.inc"         # user area configuration 

RAMALLOT reg_shadow, 256

STARTDICT

.include "dict_prims.inc" 
.include "dict_secs.inc"
.include "dict_mcu.inc"    # include with cpp
.include "dict_env.inc"

ENDDICT

.option pop                 # restore option set

