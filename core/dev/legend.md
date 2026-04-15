
# Parameter notation

symbol  | meaning
------- | ----------------------
n       | signed number, single cell
u       | unsigned number, single cell
d       | signed number, double cell ( low high )
ud      | unsigned number, double cell ( low high )
x       | single cell
f       | logical flag, 0 is false, not 0 is true
a       | cell aligned address
ca      | character aligned address
fa      | cell aligned address in FLASH
xt      | execution token (XT)
c       | character (byte)
s       | string = ( address length ) cell pair
i*x     | some unknown number of cells
"name"  | name consumed from input buffer
"ccc"   | string consumed from input buffer
wid     | XT of a wordlist word
ffa     | flag field address
lfa     | link field address
nfa     | name field address
cfa     | code field address (same as XT)
pfa     | parameter field address
loop-sys | do..loop index/limit state


# Stack notation

notation            | stack
------------------- | -------------------
( -- )              | parameter/data stack
(R: -- )            | return stack
(C: -- )            | control flow stack (data stack at compile time)
(L: -- )            | leave stack
( -- j*x || i*x )   | alternative outcomes
( -- [ j*x ] i*x )  | optional outcomes
( xu .. x1 )        | u values of type x indexed 1 to u

# Other terminology

term        | meaning
----------- | -------------------
TOS         | top of stack
NOS         | next on stack
3OS, 4OS    | 3rd, 4th, ... on stack
TIB         | terminal input buffer
PNO         | pictured numeric output
