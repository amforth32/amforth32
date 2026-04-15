# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling topforth/mlc.f on 2026/01/11 11:00:09
# \ >flash
# \ empty
# 
# \ include ./vt100.frt
# \ https://github.com/martin-h1/forth-cs-101/blob/master/mandelbrot.fs
# \ setup constants to remove magic numbers to allow
# \ for greater zoom with different scale factors.
# 20  constant maxiter
# \ -39 constant minval
# \ 40  constant maxval
# -19 constant minval
# 20  constant maxval
# 640 constant rescale
# 2560 constant s_escape
# 
# \ these variables hold values during the escape calculation.
# variable creal
# variable cimag
# variable zreal
# variable zimag
# variable ccount
# 
# : */ >r * r> / ;
# 
# \ compute squares, but rescale to remove extra scaling factor.
# : zr_sq zreal @ dup rescale */ ;
# : zi_sq zimag @ dup rescale */ ;
# 
# \ translate escape count to ascii greyscale.
# : .char
#    s" ..,'~!^:;[/<&?oxox#   "
#    drop + 1
#    $20 emit type ;
# 
# 
# \ numbers above 4 will always escape, so compare to a scaled value.
# : escapes?
#   s_escape > ;
# 
# \ increment count and compare to max iterations.
# : count_and_test?
#   ccount @ 1+ dup ccount !
#   maxiter > ;
# 
# \ stores the row column values from the stack for the escape calculation.
# : init_vars
#   5 lshift dup creal ! zreal !
#   5 lshift dup cimag ! zimag !
#   1 ccount ! ;
# 
# 
# 
# \ performs a single iteration of the escape calculation.
# : doescape
#     zr_sq zi_sq 2dup +
#     escapes? if
#       2drop
#       true
#     else
#       - creal @ +   \ leave result on stack
#       zreal @ zimag @ rescale */ 1 lshift
#       cimag @ + zimag !
#       zreal !                   \ store stack item into zreal
#       count_and_test?
#     then ;
# 
# \ iterates on a single cell to compute its escape factor.
# : docell
#   init_vars
#   begin
#     doescape
#   until
#   ccount @
#   .char ;
# 
# \ for each cell in a row.
# : dorow
#     space space space
#   maxval minval do
#     dup i
#     docell
#   loop
#   drop ;
# 
# \ for each row in the set.
# : mandelbrot
#     cr
#     maxval minval do
#         i dorow cr
#   loop ;
# 
# \ eeprom.freeze
# \ mandelbrot


CONSTANT "maxiter",MAXITER,20
CONSTANT "minval",MINVAL,-19
CONSTANT "maxval",MAXVAL,20
CONSTANT "rescale",RESCALE,640
CONSTANT "s_escape",SUNDERESCAPE,2560
VARIABLE "creal",CREAL
VARIABLE "cimag",CIMAG
VARIABLE "zreal",ZREAL
VARIABLE "zimag",ZIMAG
VARIABLE "ccount",CCOUNT

# ----------------------------------------------------------------------
COLON "zr_sq", ZRUNDERSQ 
	.word XT_ZREAL
	.word XT_FETCH
	.word XT_DUP
	.word XT_RESCALE
	.word XT_STARSLASH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "zi_sq", ZIUNDERSQ 
	.word XT_ZIMAG
	.word XT_FETCH
	.word XT_DUP
	.word XT_RESCALE
	.word XT_STARSLASH
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON ".char", DOTCHAR 
	STRING "..,'~!^:;[/<&?oxox#   "
	.word XT_DROP
	.word XT_PLUS
	.word XT_ONE
	.word XT_DOLITERAL
	.word 0x20
	.word XT_EMIT
	.word XT_TYPE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "escapes?", ESCAPESQ 
	.word XT_SUNDERESCAPE
	.word XT_GREATER
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "count_and_test?", COUNTUNDERANDUNDERTESTQ 
	.word XT_CCOUNT
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_DUP
	.word XT_CCOUNT
	.word XT_STORE
	.word XT_MAXITER
	.word XT_GREATER
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "init_vars", INITUNDERVARS 
	.word XT_DOLITERAL
	.word 5
	.word XT_LSHIFT
	.word XT_DUP
	.word XT_CREAL
	.word XT_STORE
	.word XT_ZREAL
	.word XT_STORE
	.word XT_DOLITERAL
	.word 5
	.word XT_LSHIFT
	.word XT_DUP
	.word XT_CIMAG
	.word XT_STORE
	.word XT_ZIMAG
	.word XT_STORE
	.word XT_ONE
	.word XT_CCOUNT
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "doescape", DOESCAPE 
	.word XT_ZRUNDERSQ
	.word XT_ZIUNDERSQ
	.word XT_2DUP
	.word XT_PLUS
	.word XT_ESCAPESQ
	.word XT_DOCONDBRANCH,DOESCAPE_0001 /* if */
	.word XT_2DROP
	.word XT_TRUE
	.word XT_DOBRANCH,DOESCAPE_0002
DOESCAPE_0001: # else
	.word XT_MINUS
	.word XT_CREAL
	.word XT_FETCH
	.word XT_PLUS
	.word XT_ZREAL
	.word XT_FETCH
	.word XT_ZIMAG
	.word XT_FETCH
	.word XT_RESCALE
	.word XT_STARSLASH
	.word XT_ONE
	.word XT_LSHIFT
	.word XT_CIMAG
	.word XT_FETCH
	.word XT_PLUS
	.word XT_ZIMAG
	.word XT_STORE
	.word XT_ZREAL
	.word XT_STORE
	.word XT_COUNTUNDERANDUNDERTESTQ
DOESCAPE_0002: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "docell", DOCELL 
	.word XT_INITUNDERVARS
DOCELL_0001: # begin
	.word XT_DOESCAPE
	.word XT_DOCONDBRANCH,DOCELL_0001 /* until */
	.word XT_CCOUNT
	.word XT_FETCH
	.word XT_DOTCHAR
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dorow", DOROW 
	.word XT_SPACE
	.word XT_SPACE
	.word XT_SPACE
	.word XT_MAXVAL
	.word XT_MINVAL
	.word XT_DODO
DOROW_0002: # do
	.word XT_DUP
	.word XT_I
	.word XT_DOCELL
	.word XT_DOLOOP,DOROW_0002 /* loop */
DOROW_0001: # (for ?do IF required) 
	.word XT_DROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "mandelbrot", MANDELBROT 
	.word XT_CR
	.word XT_MAXVAL
	.word XT_MINVAL
	.word XT_DODO
MANDELBROT_0002: # do
	.word XT_I
	.word XT_DOROW
	.word XT_CR
	.word XT_DOLOOP,MANDELBROT_0002 /* loop */
MANDELBROT_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
