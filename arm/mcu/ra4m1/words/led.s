
# CONTROL the built-in LED on Uno R4, GPIO pin P102
# using the per pin PmnPFS register.
# Ref: RA4M1 Group User’s Manual: 19. I/O Ports

# Write-Protect Register (PWPR)
# Have to unlock writing to PFS registers before they can be used
.equ RA4_PWPR, 0x40040D03

# 19.2.5 Port mn Pin Function Select Register (PmnPFS/PmnPFS_HA/PmnPFS_BY) (m = 0 to 9; n = 00 to 15)
# PFS.P100PFS 4004 0840h to PFS.P115PFS 4004 087Ch (32-bits)
.equ RA4_P102PFS, 0x40040848
# BITS:
# [0]  PODR   Port Output Data
# [1]  PIDR.  Port Input Data/State
# [2]  PDR.   Port Direction: 0 = Input / 1 = Output
# ...

CODEWORD  "led-init", LED_INIT
   ldr r0, =RA4_PWPR
   ldr r1, =0   @ clear B0WI bit
   strb r1, [r0]
   ldr r1, =64   @ set PFSWE bit
   strb r1, [r0]
   b PFA_LED_OFF

CODEWORD "led-off", LED_OFF
   ldr r1, =4
   ldr r0, =RA4_P102PFS
   str r1, [r0]
NEXT

CODEWORD  "led-on", LED_ON
   ldr r1, =5
   ldr r0, =RA4_P102PFS
   str r1, [r0]
NEXT
