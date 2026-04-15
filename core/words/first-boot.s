CONSTANT "first-boot.start", FIRST_BOOT_START, first_boot /* address of the first-boot page */
END FIRST_BOOT_START

CONSTANT "first-boot.marker", FIRST_BOOT_MARKER, first_boot_marker /* initial content of the first-boot page */
END FIRST_BOOT_MARKER

COLON "?first-boot", QFIRST_BOOT /* ( -- f ) booting fresh uploaded amforth for the first time? */
    .word XT_FIRST_BOOT_START, XT_FETCH, XT_FIRST_BOOT_MARKER, XT_EQUAL, XT_EXIT
END QFIRST_BOOT

COLON "first-boot.done", FIRST_BOOT_DONE /* ( -- ) mark first-boot as completed */
    .word XT_FIRST_BOOT_START, XT_FLASH_ERASE, XT_EXIT
END FIRST_BOOT_DONE
