# SPDX-License-Identifier: GPL-3.0-only

# start of flash dictionary. The 0 is the stop marker.
.macro STARTDICTNOPFA
  # .text should aready be in section amforth
  .p2align 2,0x55
VE_NOP: .word 0
97: # arch-wordlist
98: # environment
99: # forth-wordlist
# Inject a NOP word as the first entry in the dictionary.
        .word 0
        .byte 8f-7f
7:      .ascii "nop"
8:      .p2align 2,0xAA
XT_NOP: .word PFA_NOP
.endm

# save the beginning of the wordlists
.macro ENDDICT
VALUE "arch-wordlist", ARCH_WORDLIST, 97b
END ARCH_WORDLIST
VALUE "environment", ENVIRONMENT, 98b
END ENVIRONMENT
CONSTANT "core-wordlist", CORE_WORDLIST, core_wordlist
END CORE_WORDLIST
# forth-wordlist needs to be the last of the compiled words
PVALUE "forth-wordlist", FORTH_WORDLIST, 99b
.set core_wordlist , 99b
END FORTH_WORDLIST
.endm

.macro STRING string
    .word XT_DOSLITERAL
    .byte 8f - 7f
7:  .ascii "\string"
8:  .p2align 2,0x0f
.endm

.macro RAMALLOT Name, Length, Padding
    .section amramlo,"aw",%nobits    /* switch to RAM section */
    .set RAM_lower_\Name, .          
    .space \Length
    .set RAM_upper_\Name, .
    .ifnb \Padding
    .space \Padding
    .endif
    .section amforth    /* switch back to flash section */
.endm

.equ Flag_none,    0x00000000

.equ Flag_variable,   0x0001           
.equ Flag_2variable,  0x0002
.equ Flag_colon,      0x0004 
.equ Flag_constant,   0x0008 
.equ Flag_immediate,  0x0010
.equ Flag_value,      0x0020
.equ Flag_defer,      0x0040
.equ Flag_init,       0x0080
.equ Flag_table,      0x0100
.equ Flag_pvalue,     0x0200
.equ Flag_child,      0x0400
.equ Flag_alias,      0x0800

/*
  Note that ideally we would use the XT_\Label symbol as the function symbol, however, thanks to the ARM interworking garbage,
  the assembler will helpfully set the Thumb bit on all the XT_ symbols if we do, assuming they will be eventually jumped to.
  This completely breaks all the ITC code, because all the XT addresses will be off by one and the CPU will likely fault
  quite quickly on unaligned loads.
  So unfortunately we have add another set of symbols for the functions because of ARM, thus the _\Label symbols.
*/
.macro HEADERNOPFA Flags, Name, Label, PFA
    .p2align 2,0x55
VE_\Label:
    .word 99b /* LFA: Link to FFA of previous word */
    # FFA: Flag field 
99: .word \Flags
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xaa
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word \PFA
.endm

.macro HEADER Flags, Name, Label, PFA
    HEADERNOPFA \Flags, "\Name", \Label, \PFA
PFA_\Label: 
.endm

# Use to terminate the function block of a word definition
.macro END Label
    .size _\Label, . - _\Label
.endm

.macro CODEALIAS Name, Label, Target
    HEADER Flag_none, "\Name", \Label, PFA_\Target
.endm

.macro COLONALIAS Name, Label , Target
    HEADER Flag_alias, "\Name", \Label, DOALIAS
    .word PFA_\Target
    .word XT_EXIT
.endm

.macro COLON Name, Label
    HEADER Flag_colon, "\Name", \Label, DOCOLON
.endm

.macro NONAME Name, Label
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word DOCOLON
PFA_\Label: 
.endm

.macro IMMED Name, Label
    HEADER Flag_immediate, \Name, \Label, DOCOLON
.endm

.macro VARIABLE Name, Label
    HEADER Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
     # Capture current location counter
    .set \Label\()_ram, .          
    .space 4
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro NOVAR Name, Label
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word PFA_DOVARIABLE
PFA_\Label: 
    .section amramlo,"aw",%nobits
    .balign 4
     # Capture current location counter
    .set \Label\()_ram, .          
    .space 4
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro DVARIABLE Name, Label
   HEADER Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .           
    .space 8
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro NVARIABLE Name, Label, N
  HEADER Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .          
    .space 4*\N
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram            
.endm

.macro USER Name, Label, UOffset
   HEADER Flag_variable, "\Name", \Label, PFA_DOUSER
   .word \UOffset
.endm

.macro VALUE Name, Label, Default
    HEADER Flag_value|Flag_init, "\Name", \Label, PFA_DOVALUE
   .section amramlo,"aw",%nobits
   .balign 4
    # Capture current location counter
   .set \Label\()_ram, .          
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \Default
   .word XT_FETCH
   .word XT_STORE
.endm

.macro NOVAL Name, Label, Default
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word PFA_DOVALUE
PFA_\Label: 
   .section amramlo,"aw",%nobits
   .balign 4
    # Capture current location counter
   .set \Label\()_ram, .          
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \Default
   .word XT_FETCH
   .word XT_STORE
.endm

.macro PVALUE Name, Label, Default
    HEADER Flag_pvalue|Flag_init, "\Name", \Label, PFA_DOVALUE
   .section amramlo,"aw",%nobits
   .balign 4
    # Capture current location counter
   .set \Label\()_ram, .          
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \Default
   .word XT_FETCH
   .word XT_PV_STORE
.endm

.macro DEFER Name, Label, XT
    HEADER Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .section amramlo,"aw",%nobits
   .balign 4
   # Capture current location counter
   .set _\Label\()_ram, .           
   .space 4
   .section amforth
   # Write the captured address into flash
   .word _\Label\()_ram             
   .word \XT
   .word XT_FETCH
   .word XT_STORE
.endm

# see user.inc for valid labels
.macro UDEFER Name, Label, XT
    HEADER Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .word USER_\Label 
   .word \XT
   .word XT_UDEFER_FETCH
   .word XT_UDEFER_STORE
.endm

.macro CONSTANT Name, Label, NUM
    HEADER Flag_constant, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm

.macro NOCON Name, Label, NUM
    .p2align 2,0x55
    .word 0x03
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:
XT_\Label: .word PFA_DOVARIABLE
PFA_\Label: 
    .word \NUM
.endm

.macro DATA Name, Label
    HEADER Flag_none, "\Name", \Label, PFA_DODATA
.endm


# ===================
# environment contains colon words only
# ===================

.macro ENV_HEADER Flags, Name, Label, PFA
    .p2align 2,0xf0
VE_ENV_\Label:
    # LFA: Insert Link
    .word 98b          
98: # FFA: Flag field
    .word \Flags
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f     
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xf0
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:        
XT_ENV_\Label: .word \PFA
PFA_ENV_\Label:
.endm

.macro ENVIRONMENT Name, Label
    ENV_HEADER Flag_none, "\Name", \Label, DOCOLON
.endm

.macro ENV_CONSTANT Name, Label, NUM
    ENV_HEADER Flag_constant, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm

# ================================
# Arch Wordlist Entry
# different types
# ================================

.macro ARCH_HEADER Flags, Name, Label, PFA
    .p2align 2,0xf0
VE_\Label:
    # LFA: Insert Link
    .word 97b          
97: # FFA: Flag field
    .word \Flags
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f     
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xf0        
    .global _\Label
    .type _\Label, STT_FUNC
_\Label:        
XT_\Label: .word \PFA
PFA_\Label: 
.endm


  