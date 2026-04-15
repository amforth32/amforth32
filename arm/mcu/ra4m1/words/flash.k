
@ ============================================================
@ RA4M1 Code Flash P/E Routines
@   ICLK = 48 MHz, FCLK = 24 MHz, High-speed mode
@   All routines must execute from RAM
@   Disable interrupts before calling enter_cf_pe_mode
@ ============================================================

    @ ======== Register addresses ========
    .equ PRCR,      0x4001E3FE
    .equ FENTRYR,   0x407EFFB2
    .equ FPR,       0x407EC180
    .equ FPMCR,     0x407EC100
    .equ FISR,      0x407EC1D8
    .equ FRESETR,   0x407EC124
    .equ FSTATR1,   0x407EC12C
    .equ FSTATR2,   0x407EC1F0
    .equ FCR,       0x407EC114
    .equ FSARH,     0x407EC110
    .equ FSARL,     0x407EC108
    .equ FEARH,     0x407EC120
    .equ FEARL,     0x407EC118
    .equ FWBL0,     0x407EC130
    .equ FWBH0,     0x407EC138
    .equ FWBL1,     0x407EC140
    .equ FWBH1,     0x407EC144

    @ ======== Timing (48 MHz ICLK) ========
    .equ TDIS_LOOPS, 32         @ ~2 �s
    .equ TMS_LOOPS,  80         @ ~5 �s


@ ============================================================
@ write_fpmcr - Write to FPMCR via FPR unlock
@   r0 = value
@   Clobbers: r1, r2, r3
@ ============================================================
    .type write_fpmcr, %function
write_fpmcr:
    ldr     r1, =FPR
    ldr     r2, =FPMCR
    movs    r3, #0xA5
    strb    r3, [r1]            @ FPR  = 0xA5
    strb    r0, [r2]            @ FPMCR = value
    mvn     r3, r0
    strb    r3, [r2]            @ FPMCR = ~value
    strb    r0, [r2]            @ FPMCR = value
    bx      lr
.size write_fpmcr, . - write_fpmcr

@ ============================================================
@ enter_cf_pe_mode - Enter Code Flash P/E mode
@   Returns: r0 = 0
@ ============================================================
    .global enter_cf_pe_mode
    .type   enter_cf_pe_mode, %function
enter_cf_pe_mode:
    push    {r4, lr}

    ldr     r1, =PRCR
    ldr     r0, =0xA503
    strh    r0, [r1]

    ldr     r1, =FENTRYR
    ldr     r0, =0xAA01
    strh    r0, [r1]

    movs    r0, #0x12
    bl      write_fpmcr

    movs    r4, #TDIS_LOOPS
1:  subs    r4, r4, #1
    bne     1b

    movs    r0, #0x92
    bl      write_fpmcr

    movs    r0, #0x82
    bl      write_fpmcr

    movs    r4, #TMS_LOOPS
1:  subs    r4, r4, #1
    bne     1b

    ldr     r1, =FISR
    movs    r0, #23
    strb    r0, [r1]

    ldr     r1, =FRESETR
    movs    r0, #1
    strb    r0, [r1]
    movs    r0, #0
    strb    r0, [r1]

    movs    r0, #0
    pop     {r4, pc}
.size enter_cf_pe_mode, . - enter_cf_pe_mode

@ ============================================================
@ exit_cf_pe_mode - Exit to Read mode
@   Returns: r0 = 0 success, 1 failure
@ ============================================================
    .global exit_cf_pe_mode
    .type   exit_cf_pe_mode, %function
exit_cf_pe_mode:
    push    {r4, lr}

    movs    r0, #0x92
    bl      write_fpmcr

    movs    r4, #TDIS_LOOPS
1:  subs    r4, r4, #1
    bne     1b

    movs    r0, #0x12
    bl      write_fpmcr

    movs    r4, #TMS_LOOPS
1:  subs    r4, r4, #1
    bne     1b

    movs    r0, #0x08
    bl      write_fpmcr

    ldr     r1, =FENTRYR
    ldr     r0, =0xAA00
    strh    r0, [r1]

    ldrh    r0, [r1]
    cmp     r0, #0
    bne     .Lexit_fail

    ldr     r1, =PRCR
    ldr     r0, =0xA500
    strh    r0, [r1]

    movs    r0, #0
    pop     {r4, pc}

.Lexit_fail:
    movs    r0, #1
    pop     {r4, pc}
.size exit_cf_pe_mode, . -  exit_cf_pe_mode

@ ============================================================
@ erase_cf_block - Erase one 2 KB code flash block
@   r0 = block start address (2 KB aligned)
@   Returns: r0 = 0 success, 1 illegal, 2 erase error
@ ============================================================
    .global erase_cf_block
    .type   erase_cf_block, %function
erase_cf_block:
    push    {r4, lr}
    mov     r4, r0

    lsr     r0, r4, #16
    ldr     r1, =FSARH
    strh    r0, [r1]

    uxth    r0, r4
    ldr     r1, =FSARL
    strh    r0, [r1]

    add     r4, r4, #0x7FF

    lsr     r0, r4, #16
    ldr     r1, =FEARH
    strh    r0, [r1]

    uxth    r0, r4
    ldr     r1, =FEARL
    strh    r0, [r1]

    ldr     r1, =FCR
    movs    r0, #0x84
    strb    r0, [r1]

    ldr     r1, =FSTATR1
1:  ldrb    r0, [r1]
    tst     r0, #0x40
    beq     1b

    ldr     r1, =FCR
    movs    r0, #0x00
    strb    r0, [r1]

    ldr     r1, =FSTATR1
1:  ldrb    r0, [r1]
    tst     r0, #0x40
    bne     1b

    ldr     r1, =FSTATR2
    ldrb    r0, [r1]

    tst     r0, #0x10
    bne     .Lerase_ilgl

    tst     r0, #0x01
    bne     .Lerase_err

    movs    r0, #0
    pop     {r4, pc}

.Lerase_ilgl:
    ldr     r1, =FRESETR
    movs    r0, #1
    strb    r0, [r1]
    movs    r0, #0
    strb    r0, [r1]
    movs    r0, #1
    pop     {r4, pc}

.Lerase_err:
    ldr     r1, =FRESETR
    movs    r0, #1
    strb    r0, [r1]
    movs    r0, #0
    strb    r0, [r1]
    movs    r0, #2
    pop     {r4, pc}
.size erase_cf_block, . - erase_cf_block

@ ============================================================
@ program_cf - Program 8 bytes to code flash
@   r0 = destination address (8-byte aligned)
@   r1 = pointer to 8 bytes of source data in RAM
@   Returns: r0 = 0 success, 1 illegal, 2 program error
@ ============================================================
    .global program_cf
    .type   program_cf, %function
program_cf:
    push    {r4, r5, lr}
    mov     r4, r0
    mov     r5, r1

    lsr     r0, r4, #16
    ldr     r1, =FSARH
    strh    r0, [r1]

    uxth    r0, r4
    ldr     r1, =FSARL
    strh    r0, [r1]

    ldrh    r0, [r5, #0]
    ldr     r1, =FWBL0
    strh    r0, [r1]

    ldrh    r0, [r5, #2]
    ldr     r1, =FWBH0
    strh    r0, [r1]

    ldrh    r0, [r5, #4]
    ldr     r1, =FWBL1
    strh    r0, [r1]

    ldrh    r0, [r5, #6]
    ldr     r1, =FWBH1
    strh    r0, [r1]

    ldr     r1, =FCR
    movs    r0, #0x81
    strb    r0, [r1]

    ldr     r1, =FSTATR1
1:  ldrb    r0, [r1]
    tst     r0, #0x40
    beq     1b

    ldr     r1, =FCR
    movs    r0, #0x00
    strb    r0, [r1]

    ldr     r1, =FSTATR1
1:  ldrb    r0, [r1]
    tst     r0, #0x40
    bne     1b

    ldr     r1, =FSTATR2
    ldrb    r0, [r1]

    tst     r0, #0x10
    bne     .Lprg_ilgl

    tst     r0, #0x02
    bne     .Lprg_err

    movs    r0, #0
    pop     {r4, r5, pc}

.Lprg_ilgl:
    ldr     r1, =FRESETR
    movs    r0, #1
    strb    r0, [r1]
    movs    r0, #0
    strb    r0, [r1]
    movs    r0, #1
    pop     {r4, r5, pc}

.Lprg_err:
    ldr     r1, =FRESETR
    movs    r0, #1
    strb    r0, [r1]
    movs    r0, #0
    strb    r0, [r1]
    movs    r0, #2
    pop     {r4, r5, pc}
.size program_cf, . - program_cf

    .global __flash_erase__
    .type __flash_erase__, %function
__flash_erase__:
    push {r0,lr}
    cpsid   i
    bl      enter_cf_pe_mode
    mov     r0, TOS             @ erase block
    bl      erase_cf_block
    bl      exit_cf_pe_mode
    loadtos    
    cpsie   i
    pop {r0,pc}
.size __flash_erase__, . - __flash_erase__

    .global __flash_write__
    .type __flash_write__, %function
__flash_write__:
    push {r0,lr}
    cpsid   i
    bl      enter_cf_pe_mode
    mov     r0, TOS 
    ldr     r1, =FLASH_CACHE_ram
    bl      program_cf
    bl      exit_cf_pe_mode
    loadtos 
    cpsie   i
    pop {r0,pc}
.size __flash_write__, . - __flash_write__
