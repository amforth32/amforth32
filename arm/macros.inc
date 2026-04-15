
.include "core/macros.inc"

@ register usage
@ temporary volatile r0, r1, r2, r3
@ temporary callee-saved r4, r5
DEBUG   .req r6 @ used when WANT_DEBUGGER == YES
TOS     .req r7
DSP     .req r8
FW      .req r9
FIP     .req r10
UP      .req r11

@ default register mapping
@ ip .req r12 @ may be used by linker veneer for long jumps
@ sp .req r13
@ lr .req r14
@ pc .req r15

.macro NEXT
    b DO_NEXT
    .ltorg
.endm

.macro savetos @ Push TOS on Datastack - a common, often used factor.
    str TOS, [DSP, #-4]!
.endm

.macro loadtos
    ldr TOS, [DSP], #4
.endm

// push register to the data stack (n2 n1 -- n2 n1 reg)
.macro pushtos register
  savetos
  mov TOS, \register
.endm

// pop register from data stack (n2 n1 reg -- n2 n1)
.macro poptos register
  mov \register, TOS
  loadtos
.endm

// push register under TOS, leave TOS as is (n2 n1 -- n2 reg n1)
.macro pushnos register
  str \register, [DSP, #-4]!
.endm

// pop nos into register, leave TOS as is (n2 reg n1 -- n2 n1)
.macro popnos register
  ldr \register, [DSP], #4
.endm

// load loop index from user block
.macro loadindex register
  ldr \register, [up, USER_LOOP_INDEX]
.endm

// store loop index in user block
.macro storeindex register
  str \register, [up, USER_LOOP_INDEX]
.endm

// load loop limit from user block
.macro loadlimit register
  ldr \register, [up, USER_LOOP_LIMIT]
.endm

// store loop limit in user block
.macro storelimit register
  str \register, [up, USER_LOOP_LIMIT]
.endm


.macro throw exception
  savetos               /* for good order        */
  ldr TOS, =\exception   /* load exception number */
  ldr FW, =XT_THROW  /* load XT of THROW to W reg */
  b DO_EXECUTE          /* execute via ITC VM    */
.endm

/* We need to set the thumb bit on the PFA_ symbol of code words (headfull and headless),
  so that the inner interpreter can bx to it without tripping over ARM interworking
*/

.macro CODEWORD Name, Label
    HEADERNOPFA Flag_none, "\Name", \Label, PFA_\Label
.thumb_func
PFA_\Label: 
.endm

.macro HEADLESS Name, Label
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word PFA_\Label
.thumb_func
PFA_\Label: 
.endm

.macro STARTDICT
  STARTDICTNOPFA
.thumb_func
PFA_NOP:
        NEXT 
.endm

@ ================================
@ ARM Wordlist Entry
@ different types
@ ================================

.macro ARM_COLON Name, Label
    ARCH_HEADER Flag_none, "\Name", \Label, DOCOLON
.endm

.macro ARM_CONSTANT Name, Label, NUM
    ARCH_HEADER Flag_none, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm


@ ==================================
@ Debug Macro. Not used in production
@ ==================================
.macro SEMIT register
.ifdef DEBUG
   push {r0}
0: 
   ldr r0, =UARTFR
   ldr r0, [r0]
   ands r0, #TXFF
   bne 0b

   ldr r0, =UARTDR
   str \register, [r0]
   pop {r0}
.endif
.endm
