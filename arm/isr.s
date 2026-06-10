/*
   ARMv7-M Architecture Reference Manual: B1.5 exception model
   
   Exception entry:
   1) the hardware saves eight 32-bit words to the stack (non FPU context*):
      xPSR, ReturnAddress(R15), LR(R14), R12, R3, R2, R1, R0
      * non-FPU => CONTROL[2].FPCA = 0
   2) EXC_RETURN code (0xFFFFFF??) is loaded into LR (indicates return mode, stack register, saved stack frame type)

   Exception return when EXC_RETURN is loaded into PC via (LDM/POP, LDR PC or BX), e.g. BX LR:
   1) Restores registers from the saved stack frame
   2) Resumes execution at return address (unless Preempted or Tail-chaining)

   Global enable/disable interrupts instructions (priviledged more only):
   CPSID i ; Disable interrupts and configurable fault handlers (set PRIMASK)
   CPSID f ; Disable interrupts and all fault handlers (set FAULTMASK)
   CPSIE i ; Enable interrupts and configurable fault handlers (clear PRIMASK)
   CPSIE f ; Enable interrupts and fault handlers (clear FAULTMASK)
 */

.thumb_func
nullhandler:
   ldr r1, =#48
   SEMIT r1
   mrs r1, ipsr
   add r1, #48 @ +"0"
   SEMIT r1
   bx lr

.thumb_func
faulthandler:
   ldr r1, =#70 @ F
   SEMIT r1
   mrs r1, ipsr
   adds r1, #48 @ +"0"
   SEMIT r1
   bx lr
