# Default AmForth 32-bit configuration
# MCUs should import this and override as needed

# Fundamentals
# Note: .global is needed to allow linker to use the constant.

.equ cellsize, 4
.global cellsize

# RAMLO areas

.equ datastack_size, 40 * cellsize
.global datastack_size

.equ returnstack_size, 40 * cellsize
.global returnstack_size

.equ leavestack_size, 8 * cellsize
.global leavestack_size

.equ refill_buf_size, 96
.global refill_buf_size

# RAMHI areas

.equ rampool_size, 4096*2
.global rampool_size


/* C stack size */
.equ __stack_size, 2048
.global __stack_size

/* 
    Flash parameters

    Ideally all of these parameters would be defined along with other memory region parameters in the linker file,
    but some of them are needed at assembly time, so linker file location won't do.

    The defaults here are somewhat arbitrary configuration that can be used for
    faux RAM flash (usually QEMU emulated), most MCUs will need to override these in their config.inc.
 */

.equ flash_page, 1*1024
.global flash_page
.equ flash_cell, 4
.global flash_cell
.equ flash_erased, 0x00000000 /* a word in erased flash */
.global flash_erased

/*
    RA_FLASH

    Unlike other cores, RA4 flash controller does not allow rewriting flash cells at all.
    Consequently we cannot go back and patch jump targets when compiling flow words into flash.
    Moreover the RA4 flash_cell is 8 bytes, which is more than cellsize.
    To work around this, when RA_FLASH symbol is defined, we will align and allocate full flash_cell for the jump targets,
    and pad with XT_NOPs as needed.
    NOTE: It doesn't matter what value is the symbol given, what matters is that it is defined (do not define it as a NO!)

    See core/words/g-mark.s and core/words/qnop.s.
*/

# Feature flags

.equ YES , 1
.equ NO  , 0

# Optional Forth word groups

.equ WANT_FLOAT , NO

.equ WANT_DEBUGGER, YES
.equ WANT_TRANSPILER, YES

.equ WANT_CASE         , YES
.equ WANT_MATCH        , YES
.equ WANT_FORNEXT      , NO
.equ WANT_SEE          , NO
.equ WANT_CODE         , NO
.equ WANT_TABLE        , NO
.equ WANT_SYNONYM      , YES
.equ WANT_THROWTXT     , YES

# Other configuration parameters

# This can also be enabled with an environment variable with the same name
# .equ WANT_IGNORECASE, YES
