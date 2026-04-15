
ENVIRONMENT "cpu", CPU  /* ( -- addr u ) string with cpu identifier */
  .word XT_DOLITERAL,RAM_lower_uname_buf, XT_COUNT0
  .word XT_EXIT
END CPU

