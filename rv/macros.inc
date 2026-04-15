# SPDX-License-Identifier: GPL-3.0-only

.include "core/macros.inc"


# macros
#   s1 W   Forth VM W register
#   s2 IP  Forth VM IP register (ITC Instruction Pointer)
#   s3 TOS Top Of Stack
#   s4 DSP Data Stack Pointer
#   s5/SP RSP Return Stack Pointer
#   s6 UP  user area pointer
#   s7 DEBUG debugger action (used when WANT_DEBUGGER == YES)
#   t0 temp 
#   t1 temp
#   t2 temp
#   a0..a5 temp

.macro NEXT
    j DO_NEXT
.endm

.macro savetos
  addi s4, s4, -4
  sw s3, 0(s4)
.endm

.macro loadtos
  lw s3, 0(s4)
  addi s4,s4,4
.endm

.macro push register
  addi s5, s5, -4
  sw \register, 0(s5)
.endm

.macro pop register
  lw \register, 0(s5)
  addi s5, s5, 4
.endm

.macro pushdouble register1 register2
  addi s5, s5, -8  
  sw \register1, 4(s5)
  sw \register2, 0(s5)  
.endm

.macro popdouble register1 register2
  lw \register1, 4(s5)
  lw \register2, 0(s5)
  addi s4, s4, 8
.endm

.macro pushda register # Push register on Datastack
  savetos
  mv s3, \register    
.endm

.macro popda register # Pop register from Datastack
  mv \register, s3
  loadtos
.endm

.macro pushdadouble register1 register2 # Push register on Datastack
  addi s4, s4, -8
  sw s3, 4(s4)
  sw \register1, 0(s4)
  mv s3, \register2
.endm

.macro popdadouble register1 register2 # Pop register from Datastack
  mv \register1, s3
  lw \register2, 0(s4)
  lw s3, 4(s4)
  addi s4, s4, 8
.endm

# load loop index from user block
.macro loadindex register
  lw \register, USER_LOOP_INDEX(s6)
.endm

# store loop index in user block
.macro storeindex register
  sw \register, USER_LOOP_INDEX(s6)
.endm

# load loop limit from user block
.macro loadlimit register
  lw \register, USER_LOOP_LIMIT(s6)
.endm

# store loop limit in user block
.macro storelimit register
  sw \register, USER_LOOP_LIMIT(s6)
.endm


.macro CODEWORD Name, Label
    HEADER Flag_none, "\Name", \Label, PFA_\Label
.endm

.macro HEADLESS Name, Label
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word PFA_\Label
PFA_\Label: 
.endm

.macro STARTDICT
  STARTDICTNOPFA
PFA_NOP:
        NEXT 
.endm

# =====================
# CSR are RISC-V specific registers
# =====================

.macro CSR NUM, Name
  ARCH_HEADER Flag_none, "\Name", CSR_\Name, PFA_CSR_\Name
    savetos
    csrr s3, \NUM
  NEXT
.endm

.macro throw , exception
    savetos                /* for good order        */
    li s3,\exception       /* load exception number */
    la s1, XT_THROW        /* move XT to W reg      */
    j DO_EXECUTE           /* execute via ITC VM    */
.endm
