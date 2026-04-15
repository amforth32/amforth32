@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ Comparison operators

@ -----------------------------------------------------------------------------
  CODEWORD  "0=", ZEROEQUAL /* ( n -- f ) f = n == 0 */
@ -----------------------------------------------------------------------------
  subs TOS, #1
  sbcs TOS, TOS
  NEXT
END ZEROEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "0<>", NOTZEROEQUAL /* ( n -- f ) f = n != 0 */
@ -----------------------------------------------------------------------------
  subs TOS, #1
  sbcs TOS, TOS
  mvns TOS, TOS
  NEXT
END NOTZEROEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "0<", ZEROLESS /* ( n -- f ) f = n < 0 */
@ -----------------------------------------------------------------------------
  movs TOS, TOS
  asr TOS, #32    @ Turn MSB into 0xffffffff or 0x00000000
  NEXT
END ZEROLESS

@ -----------------------------------------------------------------------------
  CODEWORD  ">=", GREATEREQUAL /* ( n1 n2 -- f ) f = n1 >= n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, TOS        @ Is x2 less?
  ite lt             @ If so,
  movlt TOS, #0      @  set all bits in TOS,
  movge TOS, #-1     @  otherwise clear them all.
  NEXT
END GREATEREQUAL 

@ -----------------------------------------------------------------------------
  CODEWORD  "<=", LESSEQUAL /* ( n1 n2 -- f ) f = n1 <= n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, TOS        @ Is x2 greater?
  ite gt             @ If so,
  movgt TOS, #0      @  set all bits in TOS,
  movle TOS, #-1     @  otherwise clear them all.
  NEXT
END LESSEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "<", LESS /* ( n1 n2 -- f ) f = n1 < n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, TOS        @ Is x2 less?
  ite lt             @ If so,
  movlt TOS, #-1     @  set all bits in TOS,
  movge TOS, #0      @  otherwise clear them all.
  NEXT
END LESS

@ -----------------------------------------------------------------------------
  CODEWORD  ">", GREATER /* ( n1 n2 -- f ) f = n1 > n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, TOS        @ Is x2 greater?
  ite gt             @ If so,
  movgt TOS, #-1     @  set all bits in TOS,
  movle TOS, #0      @  otherwise clear them all.
  NEXT
END GREATER

@ -----------------------------------------------------------------------------
  CODEWORD  "u<", ULESS /* ( u1 u2 -- f ) f = u1 < u2 */
@ -----------------------------------------------------------------------------
  popnos r0      @ Get u1 into a register.
  subs TOS, r0, TOS   @ subs TOS, w, TOS   @ TOS = a-b  -- carry set if a is less than b
  sbcs TOS, TOS
  NEXT
END ULESS

@ -----------------------------------------------------------------------------
  CODEWORD  "u>", UGREATER /* ( u1 u2 -- f ) f = u1 > u2 */
@ -----------------------------------------------------------------------------
  popnos r0
  subs TOS, r0
  sbcs TOS, TOS
  NEXT
END UGREATER

@ -----------------------------------------------------------------------------
  CODEWORD  "<>", NOTEQUAL /* ( n1 n2 -- f ) f = n1 != n2 */
@ -----------------------------------------------------------------------------
  popnos r0      @ Get the next elt into a register.
  subs TOS, r0        @ Z=equality; if equal, TOS=0

  it ne             @ If not equal,
  movne TOS, #-1    @  set all bits in TOS.
  NEXT
END NOTEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "=", EQUAL /* ( n1 n2 -- f ) f = n1 == n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get the next elt into a register.
  subs TOS, r0       @ Z=equality; if equal, TOS=0

  subs TOS, #1       @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs TOS, TOS
  NEXT
END EQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "min", MIN /* ( n1 n2 -- n3 ) n3 = min(n1, n2) */
@ -----------------------------------------------------------------------------
  popnos r0       @ Get x1 into a register.
  cmp r0, TOS          @ Compare them.
  it lt                @ If X is less,
  movlt TOS, r0        @  replace TOS with it.
  NEXT
END MIN

@ -----------------------------------------------------------------------------
  CODEWORD  "max", MAX /* ( n1 n2 -- n3 ) n3 = max(n1, n2) */
@ -----------------------------------------------------------------------------
  popnos r0       @ Get x1 into a register.
  cmp r0, TOS          @ Compare them.
  it gt                @ If X is greater,
  movgt TOS, r0        @  replace TOS with it.
  NEXT
END MAX

@ -----------------------------------------------------------------------------
  CODEWORD  "umax", UMAX /* ( u1 u2 -- u3 ) u3 = max(u1, u2) */
@ -----------------------------------------------------------------------------
  popnos r0  @ Get u1 into a register.
  cmp r0, TOS 
  it hi           @ If W > TOS,
  movhi TOS, r0   @  replace TOS with W.
  NEXT
END UMAX

@ -----------------------------------------------------------------------------
  CODEWORD  "umin", UMIN /* ( u1 u2 -- u3 ) u3 = min(u1, u2) */
@ -----------------------------------------------------------------------------
  popnos r0  @ Get u1 into a register.
  cmp r0, TOS
  it lo           @ If W < TOS,
  movlo TOS, r0   @  replace TOS with W.
  NEXT
END UMIN

