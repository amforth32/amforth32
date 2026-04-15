# SPDX-License-Identifier: GPL-3.0-only

COLON "<builds", BUILDS /* (C: "name" -- )( -- ) build dictionary header for name */
/*

 Skip leading space delimiters. Parse name delimited by a space. Build
 a definition for name but does NOT compile an execution token (XT).
 Instead it leaves a suitably padded space in the memory backing the
 dictionary so that an XT can (and must) be written to that space by DOES>

 Typical usage would be

 : farm <builds , does> @ 1+ ;
 1 farm cat
 where cat would leave 2 in TOS

 A more convenient usage is to add the word builds>

 : farm <builds , builds> does> @ 1+ ;
 2 farm dog
 where dog would leave 3 in TOS

 builds> compiles EXIT at the end of the child word, which wilst never
 reached is the end of word marker for SEE - which allows child to be
 deconstructed by SEE.

 name execution: ( -- a-addr )
 a-addr is the address of name's data field.
 The execution semantics of name MUST be extended by using DOES>.
 
*/
    .word XT_FLAGDOTCHILD
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    
.if RA_FLASH == YES

    .word XT_MEMMODE , XT_DOCONDBRANCH , 1f
    
    .word XT_FLASH_CELL        /* if current DP is flash.cell aligned    */
    .word XT_DP                /* then there is nothing to do. However,  */
    .word XT_NALIGNED          /* if it is not then we need to insert    */
    .word XT_DP                /* a cell after the end NFA related cells */ 
    .word XT_MINUS             /* so that the space for the XT or CFA is */
    .word XT_DOCONDBRANCH , 1f /* 0 = aligned so branch and do nothing   */
    .word XT_ZERO              /* not aligned so lay down a zero         */
    .word XT_COMMA

1:
.endif

    .word XT_REVEAL
    
    .word XT_MEMMODE , XT_DOCONDBRANCH , 1f
    .word XT_DP
    .word XT_CELLPLUS

.if RA_FLASH == YES
    /* flash.cell of RA_FLASH is atomic - it can only be written once    */
    /* and in entirety without page erase . It is not possible to write  */
    /* -1 to one cell of flash.cell and then comeback and read, modifiy, */
    /* re-write. So need to prepare space for a single atomic write      */
    .word XT_CELLPLUS
.endif 

    .word XT_DOTO
    .word XT_DP
    .word XT_DOBRANCH , 2f
    
1:  .word XT_DOLITERAL
    .word -1
    .word XT_COMMA 
2:     

    .word XT_EXIT
END BUILDS

COLON "builds>", ENDBUILDS /* (C: "name" -- )( -- ) add exit <builds ... builds> ... does> ... ; (so SEE will work) */
    .word XT_DALIGN
    .word XT_COMPILE
    .word XT_EXIT
    .word XT_EXIT
END ENDBUILDS

