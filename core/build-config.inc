/* 
    Finalize the build configuration based on settings from config.inc files
    At this point all configuration should be settled to make sure all words
    will be compiled with the same settings.

    Be careful to check the settings correctly, e.g. if settings is defined as
        .equ OPTION_X, NO
    checking the options with .ifdef OPTION_X won't do the right thing.
    Usually the best way is to check the setting with
        .if OPTION_X == YES
*/

/*
    BUILD_CONFIG value has a bit allocated for each important configuration setting.
    Corresponding bit is set when the setting is enabled.
    The bits can be checked with predefined bit symbols named CFG_<setting>.
*/
.equ BUILD_CONFIG, 0

.equ CFG_WANT_IGNORECASE, 1
.if WANT_IGNORECASE == YES
.equ BUILD_CONFIG, BUILD_CONFIG | CFG_WANT_IGNORECASE
.endif

/* If flash writes require more than one cell worth,
   we need to trigger flushes at specific points of the compilation cycle. 
   see references to XT_FLASHDOTFLUSH */
.equ CFG_FLUSH_REQUIRED, 2
.if flash_cell > cellsize
.equ FLUSH_REQUIRED, YES
.equ BUILD_CONFIG, BUILD_CONFIG | CFG_FLUSH_REQUIRED
.print "INFO: using FLUSH_REQUIRED"
.endif

.equ CFG_RA_FLASH, 4
.if RA_FLASH == YES
.print "INFO: using RA_FLASH"
.equ BUILD_CONFIG, BUILD_CONFIG | CFG_RA_FLASH
.endif
