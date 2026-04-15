
ENVIRONMENT "/user", SLASH_USER /* ( -- u ) size of the user area */
    .word XT_DOLITERAL, userarea_size
    .word XT_EXIT
END SLASH_USER
