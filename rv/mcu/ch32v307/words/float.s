# SPDX-License-Identifier: GPL-3.0-only
# This is only for float related words only 


#CODEWORD "f.strtof" , TO_FLOAT
#         savetos
#         jal tofloat
#         mv s3,a0
#         NEXT 


CODEWORD "qqq" , QQQ
         jal qqq
         NEXT

HEADLESS "(f.)" , LPARENFDOTRPAREN
         fmv.w.x fa0, s3 
         jal print_float
         loadtos
         NEXT 

COLON "f." , FLOATDOT # ( -- ) FLOAT: Display TOS as float according to float.fmt
         .word XT_LPARENFDOTRPAREN
         .word XT_FLOAT_OUT
         .word XT_COUNT
         .word XT_TYPE
         .word XT_EXIT

CODEWORD "ptest" , PTEST
         fmv.w.x fa0, s3 
         jal pass_test
         fmv.x.w s3, fa0 
         NEXT 


CODEWORD "(>f)", RTEST
         jal scan_float
         savetos 
         fmv.x.w s3 , fa0
         savetos 
         mv s3 , a0
         NEXT

CODEWORD "s>f" , S_TO_F # ( n -- float ) FLOAT: convert n to IEEE754 float 
         fcvt.s.w fa0 , s3
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "fsqrt" , FSQRT # ( float -- float ) FLOAT: sqrt(TOS)  
         fmv.w.x fa0 , s3
         jal sqrt_float
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "f+" , FPLUS # ( fl1 fl2 -- float ) FLOAT: fl1 + fl2 
         fmv.w.x fa0 , s3
         loadtos
         fmv.w.x fa1 , s3
         fadd.s fa0 , fa0 , fa1
         fmv.x.w s3 , fa0
         NEXT 

CODEWORD "f-" , FMINUS # ( fl1 fl2 -- float ) FLOAT: fl1 - fl2 
         fmv.w.x fa0 , s3
         loadtos
         fmv.w.x fa1 , s3
         fsub.s fa0 , fa1 , fa0
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "f*" , FSTAR # ( fl1 fl2 -- float ) FLOAT: fl1 * fl2 
         fmv.w.x fa0 , s3
         loadtos
         fmv.w.x fa1 , s3
         fmul.s fa0 , fa0 , fa1
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "f/" , FSLASH # ( fl1 fl2 -- float ) FLOAT: fl1 / fl2 
         fmv.w.x fa0 , s3
         loadtos
         fmv.w.x fa1 , s3
         fdiv.s fa0 , fa1 , fa0
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "fnegate" , FNEGATE # ( float -- float ) FLOAT: negate TOS  
         li t0 , 0x80000000  # 1 31 lshift 
         xor s3 , s3 , t0
         NEXT

CODEWORD "fabs" , FABS # ( float -- float ) FLOAT: abs(TOS)
         li t0 , 0x80000000  # 1 31 lshift 
         or  s3 , s3 , t0    # make signbit 1 
         xor s3 , s3 , t0    # make signbit 0 
         NEXT

CODEWORD "fsin" , FSIN # ( float -- float ) FLOAT: sine(TOS)
         fmv.w.x fa0 , s3
         jal sin_float
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "fcos" , FCOS # ( float -- float ) FLOAT: cosine(TOS)
         fmv.w.x fa0 , s3
         jal cos_float
         fmv.x.w s3 , fa0
         NEXT

CODEWORD "ftan" , FTAN # ( float -- float ) FLOAT: tangent(TOS)
         fmv.w.x fa0 , s3
         jal tan_float
         fmv.x.w s3 , fa0
         NEXT


CONSTANT "f.pi" , FPI , 0x40490fdb # ( -- float ) FLOAT: Pi  
CONSTANT "f.e"  , FE  , 0x402df854 # ( -- float ) FLOAT: e  
# f.1 f.2 



.ifnb YES
CONSTANT "f.in"  , F_IN  , float_buffer_in
CONSTANT "f.out" , F_OUT , float_buffer_out

CONSTANT "float.in"  , FLOAT_IN  , float_in
CONSTANT "float.out" , FLOAT_OUT , float_out
CONSTANT "float.fmt" , FLOAT_FMT , float_fmt


.endif
