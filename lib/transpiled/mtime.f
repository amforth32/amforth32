\# # SPDX-License-Identifier: GPL-3.0-only

{
/*
On the QEMU virt machine, mtime is at address 0x200BFF8 and
ticks at 10 MHz (1 tick = 100 ns, 10000 ticks = 1 ms). It is a 64 bit
counter but only the low word is used. No init is required. 

https://docs.riscv.org/reference/isa/extensions/priv-1p13/_attachments/riscv-privileged-priv_1_13.pdf

*/
}

$0200BFF8 constant mtime         \ 64-bit, lo word first
$02004000 constant mtimecmp      \ + 8*hartid
#10000000 constant mtime.hz

\ --- reads ---

{
# ----------------------------------------------------------------------
.equ MTIME_LO, 0x0200BFF8                                                                                
                                                                                                         
CODEWORD "mtime@", MTIMEFETCH /* ( -- n ) read RV low 32 bits of 64 bit RV machine counter  */        
    savetos                                                                                              
    li t0, MTIME_LO
    lw s3 , 0(t0)                                                                                        
    NEXT                                                                                                 
END MTIMEFETCH                                                                                           
}

\# : mtime@  \# ( -- u ) low 32 bits of 64 bit RV machine counter 
\#    mtime @
\# ;                    \ low 32: deltas, ms

: mtime2@ \# ( -- ud ) 64 bit RV machine counter as ud 
   begin  mtime cell+ @  mtime @  mtime cell+ @  ( h1 l h2 )
      rot over =  dup 0= if >r 2drop r> then
   until ;                                       ( lo hi )

\ --- compare (glitch-free 64-bit write on RV32) ---

: mtimecmp! \# ( ud -- ) set 64 bit RV machine counter alarm 
    -1 mtimecmp !  mtimecmp cell+ !  mtimecmp !
;

: mtimecmp@ \# ( -- ud ) read 64 bit RV machine counter alarm 
    mtimecmp @  mtimecmp cell+ @
;

: mtime- \# ( -- ) clear RV machine counter alarm 
    -1 -1 mtimecmp!
;  
