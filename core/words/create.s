# SPDX-License-Identifier: GPL-3.0-only

COLON "create", CREATE /* (C: "name" -- )( -- a-addr ) create dictionary header for name (DATA) */
/*
 Skip leading space delimiters. Parse name delimited by a space. Create a definition for name with the execution semantics defined below.
 If the data-space pointer is not aligned, reserve enough data space to align it. The new data-space pointer defines name's data field.
 CREATE does not allocate data space in name's data field.

 name execution: ( -- a-addr )
 a-addr is the address of name's data field. The execution semantics of name may be extended by using DOES>.
*/
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DODATA
    .word XT_EXIT
END CREATE
