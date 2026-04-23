# SPDX-License-Identifier: GPL-3.0-only

# 19.2.6 Write-Protect Register (PWPR)

.equ RA4_PWPR, 0x40040D03

CODEWORD "pfs.unlock" , PFSDOTUNLOCK /* ( -- ) allow PSF registers to be modifed */
   ldr r0, =RA4_PWPR
   ldr r1, =0   @ clear B0WI bit
   strb r1, [r0]
   ldr r1, =64   @ set PFSWE bit
   strb r1, [r0]
NEXT

CODEWORD "pfs.lock" , PFSDOTLOCK /* ( -- ) forbid modification of PSF registers */
   ldr r0, =RA4_PWPR
   ldr r1, =0        @ clear PFSWE bit first
   strb r1, [r0]
   ldr r1, =128      @ set B0WI bit (0x80) — locks PWPR against further writes
   strb r1, [r0]
NEXT



   
