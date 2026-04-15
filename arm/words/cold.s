CODEWORD "cold", COLD /* ( i*x -- )(R: j*y -- ) assembler part of startup sequence, booting the VM */
/* This is assembly part of the startup sequence that creates the basic runtime environment for the virtual machine.
   It sets up the hardware, the stack pointers and the forth registers for the WARM word, 
   then boots the virtual machine by jumping to the inner interpreter.

   MCUs may override this to inject additional initialization at specific points.
*/
   ldr r0, =RAM_upper_returnstack
   mov sp, r0
   ldr DSP, =RAM_upper_datastack

.if WANT_DEBUGGER == YES
   mov DEBUG, 0
.endif

/* Copy RAM functions from Flash to RAM */
   ldr r0, =RAM_lower_res    
   ldr r1, =FSH_lower_res    
   ldr r2, =RAM_upper_res    

copy_ramfunc:
   cmp r0, r2
   beq done_copy
   ldr r3, [r1], #4
   str r3, [r0], #4
   b copy_ramfunc
    
done_copy:
   ldr FW, =XT_WARM
   b DO_EXECUTE

END COLD
