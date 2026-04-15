/* SPDX-License-Identifier: GPL-3.0-only */

#CONSTANT "XT.COLON"    , CON_COLON, DOCOLON
#CONSTANT "XT.VARIABLE" , CON_VARIABLE, PFA_DOVARIABLE
#CONSTANT "XT.EXIT"     , CON_EXIT  , XT_EXIT
#CONSTANT "PFA.DEFER"   , CON_DEFER , PFA_DODEFER
#CONSTANT "PFA.VALUE"   , CON_VALUE , PFA_DOVALUE
#CONSTANT "XT.DOCONDBRANCH" , CON_DOCONDBRANCH, XT_DOCONDBRANCH            
CONSTANT "XT.DONEXT" , CON_DONEXT, DO_NEXT
#CONSTANT "XT.EXECUTE" , CON_EXECUTE, DO_EXECUTE

#CONSTANT "PFA.DODATA" , CON_DODATA, PFA_DODATA
#CONSTANT "PFA.DOUSER" , CON_DOUSER, PFA_DOUSER

/* FIX THIS */

# COLON "compile?" , COMPILEQ /* ( a -- f ) f is true if a contains XT of COMPILE  */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word XT_COMPILE
#       .word XT_EQUAL
#       .word XT_EXIT

# COLON "literal?" , LITERALQ /* ( a -- f ) f is true if a contains XT of DOLITERAL  */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word XT_DOLITERAL
#       .word XT_EQUAL
#       .word XT_EXIT

# COLON "xliteral?" , XLITERALQ /* ( a -- f ) f is true if a contains XT of DOXLITERAL  */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word XT_DOXLITERAL
#       .word XT_EQUAL
#       .word XT_EXIT

COLON "sliteral?" , SLITERALQ /* ( a -- f ) f is true if a contains XT of DOSLITERAL  */
      .word XT_FETCH
      .word XT_DOLITERAL
      .word XT_DOSLITERAL
      .word XT_EQUAL
      .word XT_EXIT

# COLON "loop?" , LOOPQ /* ( a -- f ) f is true if [a] is XT of DOLOOP | DOPLUSLOOP  */
#       .word XT_FETCH
#       .word XT_DUP
#       .word XT_DOLITERAL
#       .word XT_DOLOOP
#       .word XT_EQUAL
#       .word XT_SWAP
#       .word XT_DOLITERAL
#       .word XT_DOPLUSLOOP
#       .word XT_EQUAL
#       .word XT_OR 
#       .word XT_EXIT

# COLON "condbranch?", CONDBRANCHQ /* ( a -- f ) f is true if a contains XT of DOCONDBRANCH */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word XT_DOCONDBRANCH
#       .word XT_EQUAL
#       .word XT_EXIT

# COLON "branch?", BRANCHQ /* ( a -- f ) f is true if a contains XT of DOBRANCH */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word XT_DOBRANCH
#       .word XT_EQUAL
#       .word XT_EXIT

# COLON "anybranch?", ANYBRANCHQ /* ( a -- f ) f is true if a contains XT of any branch */
#       .word XT_DUP
#       .word XT_CONDBRANCHQ
#       .word XT_OVER
#       .word XT_BRANCHQ
#       .word XT_OR
#       .word XT_SWAP
#       .word XT_LOOPQ
#       .word XT_OR 
#       .word XT_EXIT

COLON "colon?" , COLONQ /* ( a -- f ) f is true if a contains XT of DOCOLON  */
      .word XT_FETCH
      .word XT_DOLITERAL
      .word DOCOLON
      .word XT_EQUAL
      .word XT_EXIT

# COLON "codeword?" , CODEWORDQ /* ( a -- f ) f is true if a contains XT of CODEWORD */
#       .word XT_DUP
#       .word XT_FETCH
#       .word XT_SWAP
#       .word XT_CELLPLUS
#       .word XT_EQUAL
#       .word XT_EXIT
      
COLON "exit?" , EXITQ  /* ( a -- f ) f is true if [a] is XT of EXIT | EXITI */
      .word XT_FETCH
      .word XT_DUP
      .word XT_DOLITERAL
      .word XT_EXIT
      .word XT_EQUAL
      .word XT_SWAP
      .word XT_DOLITERAL
      .word XT_EXITI
      .word XT_EQUAL
      .word XT_OR 
      .word XT_EXIT

# COLON "variable?" , VARIABLEQ /* ( a -- f ) f is true if [a] is XT for a variable */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word PFA_DOVARIABLE
#       .word XT_EQUAL
#       .word XT_EXIT

# COLON "value?" , VALUEQ /* ( a -- f ) f is true if [a] is XT for a value */
#       .word XT_FETCH
#       .word XT_DOLITERAL
#       .word PFA_DOVALUE
#       .word XT_EQUAL
#       .word XT_EXIT

/* brain damaged string */
.macro BDAM string
    .byte 8f - 7f
7:  .ascii "\string"
8:  .p2align 2,0x0f
.endm

REGNUM:
        BDAM "x0"  
        BDAM "x1"  
        BDAM "x2"  
        BDAM "x3"   
        BDAM "x4"  
        BDAM "x5"  
        BDAM "x6"  
        BDAM "x7"  
        BDAM "x8"  
        BDAM "x9"  
        BDAM "x10" 
        BDAM "x11" 
        BDAM "x12" 
        BDAM "x13" 
        BDAM "x14" 
        BDAM "x15" 
        BDAM "x16" 
        BDAM "x17" 
        BDAM "x18" 
        BDAM "x19" 
        BDAM "x20" 
        BDAM "x21" 
        BDAM "x22" 
        BDAM "x23" 
        BDAM "x24" 
        BDAM "x25" 
        BDAM "x26" 
        BDAM "x27" 
        BDAM "x28" 
        BDAM "x29" 
        BDAM "x30" 
        BDAM "x31" 

REGABI:
        BDAM "zer"  
        BDAM "ra"  
        BDAM "sp"  
        BDAM "gp"   
        BDAM "tp"  
        BDAM "t0"  
        BDAM "t1"  
        BDAM "t2"  
        BDAM "s0"  
        BDAM "s1"  
        BDAM "a0" 
        BDAM "a1" 
        BDAM "a2" 
        BDAM "a3" 
        BDAM "a4" 
        BDAM "a5" 
        BDAM "a6" 
        BDAM "a7" 
        BDAM "s2" 
        BDAM "s3" 
        BDAM "s4" 
        BDAM "s5" 
        BDAM "s6" 
        BDAM "s7" 
        BDAM "s8" 
        BDAM "s9" 
        BDAM "s10" 
        BDAM "s11" 
        BDAM "t3" 
        BDAM "t4" 
        BDAM "t5" 
        BDAM "t6" 

REGITC:
        BDAM "zer"  
        BDAM "ra"  
        BDAM "sp"  
        BDAM "gp"   
        BDAM "tp"  
        BDAM "t0"  
        BDAM "t1"  
        BDAM "t2"  
        BDAM "s0"  
        BDAM "W"  
        BDAM "a0" 
        BDAM "a1" 
        BDAM "a2" 
        BDAM "a3" 
        BDAM "a4" 
        BDAM "a5" 
        BDAM "a6" 
        BDAM "a7" 
        BDAM "IP" 
        BDAM "TOS" 
        BDAM "DSP" 
        BDAM "RSP" 
        BDAM "UP" 
        BDAM "DEBUG" 
        BDAM "s8" 
        BDAM "s9" 
        BDAM "s10" 
        BDAM "s11" 
        BDAM "t3" 
        BDAM "t4" 
        BDAM "t5" 
        BDAM "t6" 

/* BDAM "x0"   */
/* BDAM "x1"   */
/* BDAM "RSP"   */
/* BDAM "TOS"    */
/* BDAM "DSP"   */
/* BDAM "x5"   */
/* BDAM "x6"   */
/* BDAM "x7"   */
/* BDAM "LPI"   */
/* BDAM "LPL"   */
/* BDAM "x10"  */
/* BDAM "x11"  */
/* BDAM "x12"  */
/* BDAM "x13"  */
/* BDAM "x14"  */
/* BDAM "x15"  */
/* BDAM "IP"  */
/* BDAM "W"  */
/* BDAM "UP"  */
/* BDAM "x19"  */
/* BDAM "A"  */
/* BDAM "B"  */
/* BDAM "x22"  */
/* BDAM "x23"  */
/* BDAM "x24"  */
/* BDAM "x25"  */
/* BDAM "x26"  */
/* BDAM "x27"  */
/* BDAM "x28"  */
/* BDAM "x29"  */
/* BDAM "x30"  */
/* BDAM "x31"  */

CONSTANT "REGNUM" , CON_REGNUM, REGNUM
CONSTANT "REGABI" , CON_REGABI, REGABI
CONSTANT "REGITC" , CON_REGITC, REGITC

/* VALUE "REGNAME", REGNAME, REGITC */



