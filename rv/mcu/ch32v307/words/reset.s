# SPDX-License-Identifier: GPL-3.0-only
# reset
# p26 manual & p95 of manual

.equ R32_PFIC_CFGR , 0xE000E048 # PFIC interrupt configuration register
.equ KEY3          , 0xBEEF0000 # 
CODEWORD "reset" , RESET # ( -- ) SYSTEM: reset the mcu 

         li  t0, R32_PFIC_CFGR
         li  t1, KEY3
         ori t1, t1, (1<<7)
         sw  t1, 0(t0)
         NEXT

