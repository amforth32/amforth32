# SPDX-License-Identifier: GPL-3.0-only

.equ R32_FLASH_KEYR     , 0x40022004 # FPEC key register X
.equ R32_FLASH_OBKEYR   , 0x40022008 # OBKEY register X 
.equ R32_FLASH_STATR    , 0x4002200C # Status register 0x00000000
.equ R32_FLASH_CTLR     , 0x40022010 # Control register 0x00000080
.equ R32_FLASH_ADDR     , 0x40022014 # Address register 0x00000000
.equ R32_FLASH_OBR      , 0x4002201C # Selection word register 0x03FFFFFC
.equ R32_FLASH_WPR      , 0x40022020 # Write protection register 0xFFFFFFF
.equ R32_FLASH_MODEKEYR , 0x40022024 # Extension key register X

CODEWORD "fast.write" , FASTDOTWRITE /* ( a-ram a-flash -- ) FLASH: write 256 bytes at a-ram to a-flash */

        li t0 , 0xFFFFFF00 
        mv t3 , s3              # flash address
        and t3 , t3, t0
        li t0 , 0x08000000      # flash offset
        add t3 , t3 , t0 
        lw t4 , 0(s4)           # ram address  
        li t5 , 64              # counter  
        
        li t0, R32_FLASH_CTLR   # set program flag 
        lw t1, 0(t0)
        li t2, (1<<16)          # FTPG RW Perform a fast page programming operation 
        or t1, t1, t2    
        sw t1, 0(t0)

        li t0, R32_FLASH_STATR  # wait.busy 
1:      lw t1, 0(t0)
        andi t1,t1, (1 << 0)
        bne t1,zero,1b
        
        li t0, R32_FLASH_STATR  # wait.writing 
1:      lw t1, 0(t0)
        andi t1,t1, (1 << 1)
        bne t1,zero,1b 

        # s3 is working 

2:      lw s3, 0(t4)            # load from ram ...
        sw s3, 0(t3)            # ... store in flash

        addi t4, t4, 4          # increment ram
        addi t3, t3, 4          # increment flash
        addi t5, t5, -1         # decrement counter
        
        li t0, R32_FLASH_STATR  # wait.writing 
1:      lw t1, 0(t0)
        andi t1,t1, (1 << 1)
        bne t1,zero,1b 

        bne t5,zero,2b          # loop over 64 words 

        li  t0, R32_FLASH_CTLR  # start program 
        lw  t1, 0(t0)
        li  t2, (1<<21)
        or  t1,t1,t2
        sw  t1, 0(t0)

        
        li t0, R32_FLASH_STATR  # wait.busy 
1:      lw t1, 0(t0)
        andi t1,t1, (1 << 0)
        bne t1,zero,1b

        li  t0, R32_FLASH_CTLR  # clear program flag 
        lw  t1, 0(t0)
        li  t2, ~(1<<16)        # FTPG RW clear fast page programming operation 
        and t1, t1, t2    
        sw  t1, 0(t0)


        li t0, R32_FLASH_STATR  # wait.busy 
1:      lw t1, 0(t0)
        andi t1,t1, (1 << 0)
        bne t1,zero,1b

        lw s3 , 4(s4)
        addi s4 , s4 , 8

        NEXT
END FASTDOTWRITE

CODEWORD "fast.unlock", FASTDOTUNLOCK /* ( -- ) EEPROM: Unlock eeprom (fast flash) */

      li t0 , R32_FLASH_KEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)

      li t0 , R32_FLASH_MODEKEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)

      NEXT
END FASTDOTUNLOCK

CODEWORD "fast.erase" , FASTDOTERASE # ( fa -- ) EEPROM: Erase 256B eeprom ( fast flash )

      
      li  t1 , 0x08000000     # offset 
      add s3 , s3 , t1 
      li  t1 , 0xFFFFFF00     # make the page address 
      and t0 , s3 , t1        # 

      li  t3, R32_FLASH_ADDR  # store page address 
      sw  t0, 0(t3)           #

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, (1<<17)         # fast 256 byte page erase
      or  t1, t1, t2          # ...
      sw  t1, 0(t0)           # save in preparation

      lw  t1, 0(t0)           # t0 still has R32_FLASH_CTLR
      ori t1, t1, (1<<6)      # 
      sw  t1, 0(t0)           # start erasing...

      li   t3, R32_FLASH_STATR
1:    lw   t1, 0(t3)          # contents of status
      andi t1, t1, 1          # busy
      bne  t1, zero, 1b       # branch if busy (t1!=0)

      lw  t1, 0(t0)           # t0 still has R32_FLASH_CTLR
      li  t2, ~(1<<17)        # clear the erase flag
      and t1, t1, t2          # ...
      sw  t1, 0(t0)           # save in preparation
      loadtos 

      NEXT
END FASTDOTERASE

CODEWORD "fast.lock", FASTDOTLOCK # ( -- ) EEPROM: Lock eeprom (flash)

         li t0, R32_FLASH_CTLR
         lw t1, 0(t0)
         ori t1,t1, (1 << 7)
         sw t1, 0(t0)
         NEXT
END FASTDOTLOCK
       


