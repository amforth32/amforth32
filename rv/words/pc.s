# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "pc", PC /* ( -- u ) u is the value of program counter (PC) */
  savetos
  auipc s3,0
  NEXT
END PC