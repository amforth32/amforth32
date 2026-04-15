
/* syscall write 0x4, args: unsigned int fd, const char *buf, size_t count */
CODEWORD "stdout", SERIAL_EMIT
  savetos  
  mov  r0, #1   @ File descriptor 1: STDOUT
  mov  r1, DSP   @ Pointer to Message
  mov  r2, #1   @ 1 Byte
  mov  r7, #4   @ Syscall 4: Write
  swi #0
  loadtos
  loadtos
  NEXT
END SERIAL_EMIT

COLON "stdout?", SERIAL_EMITQ
   .word XT_PAUSE,XT_TRUE, XT_EXIT
END SERIAL_EMITQ

/* syscall read #3, args: unsigned int fd, char *buf, size_t count */
CODEWORD "stdin", SERIAL_KEY
  savetos
  mov TOS, #0
  savetos @ create room on DS for the incoming character
  
  mov  r0, #0   @ File descriptor 0: STDIN
  mov  r1, DSP   @ Pointer to Message
  mov  r2, #1   @ 1 Byte
  mov  r7, #3   @ Syscall 3: Read
  swi #0
  
  cmp r0, #0 @ A size of zero bytes or less denotes EOF.
  ble.n PFA_BYE

  loadtos
  cmp TOS, #4 @ Ctrl-D
  beq.n PFA_BYE
  NEXT
END SERIAL_KEY

COLON "stdin?", SERIAL_KEYQ
   .word XT_PAUSE, XT_TRUE, XT_EXIT
END SERIAL_KEYQ

CODEWORD "cacheflush", CACHEFLUSH @ ( -- )
  push {r6, r7}

  dmb
  dsb
  isb  
  
  ldr r0, =dp0.ram  @ Start address
  ldr r1, =dp.ram.max    @ End  address
  movs r2, #0          @ This zero is important !s
  movs r3, #0
  movs r4, #0
  movs r5, #0
  movs r6, #0
  ldr r7, =0x000f0002  @ Syscall __ARM_NR_cacheflush
  swi #0

  pop {r6, r7}
  NEXT
END CACHEFLUSH


CODEWORD "bye", BYE
  mov  r0, TOS @ Error code 
  mov  r7, #1  @ Syscall 1: Exit
  swi #0
NEXT

CODEWORD "syscall", SYSCALL @ ( r0 r1 r2 r3 r4 r5 Syscall# -- r0 )
  @ TOS is r7, already has the syscall number
  popnos r5
  popnos r4
  popnos r3
  popnos r2
  popnos r1
  popnos r0
  swi #0

  movs TOS, r0  @ Syscall reply into TOS
  NEXT
END SYSCALL

VARIABLE "argv", ARGV

RAMALLOT "uname_buf", 512 @ contains struct old_utsname after uname call
/*
  struct old_utsname {
    char sysname[65];  // Operating system name (e.g., "Linux") 
    char nodename[65]; // Name within "some implementation-defined network" 
    char release[65];  // Operating system release (e.g., "2.6.28") 
    char version[65];  // Operating system version 
    char machine[65];  // Hardware identifier 
  };
*/

COLON "uname", UNAME
  .word XT_DOLITERAL,RAM_lower_uname_buf @ r0
  .word XT_ZERO, XT_ZERO, XT_ZERO, XT_ZERO, XT_ZERO @ r1...r5
  .word XT_DOLITERAL, 122 @ syscall nr (uname)
  .word XT_SYSCALL, XT_DROP
  .word XT_EXIT
END UNAME

ENVIRONMENT "hostname", HOSTNAME
  .word XT_DOLITERAL, RAM_lower_uname_buf+0x41, XT_COUNT0
  .word XT_EXIT
END HOSTNAME
