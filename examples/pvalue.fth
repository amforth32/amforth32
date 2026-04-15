
\ A test script demonstrating the pvalue functionality with fake RAM based PVFLASH
\ Do not use this on real MCU it will wipe your PVFLASH (see below)
hex

\ Make sure arenas are "erased" to the expected blank flash state
pvarena1 pvarena.erase
pvarena1 10 - 5 dump \ check arena1
pvarena2 pvarena.erase
pvarena2 10 - 5 dump \ check arena2

\ show initial setup
pv.init
pvp .
pvarena .
pvarena 10 - 5 dump

\ update pvalues multiple times
vaddr pv1 . \ RAM address of pv1
pv1 .       \ value of pv1
1 vaddr pv1 pv.store
pv1 .
2 vaddr pv1 pv.store
pv1 .

vaddr pv2 . \ RAM address of pv2
pv2 .       \ value of pv1
3 vaddr pv2 pv.store
pv2 .

4 vaddr pv1 pv.store
pv1 .

5 vaddr pv2 pv.store
pv2 .

pvarena 10 - 5 dump \ show the arena
pvp .

\ reset the values and pvp
0 is pvp
0 vaddr pv1 !
pv1 .

0 vaddr pv2 !
pv2 .


pv.init \ reinitialize pvalue system
pv1 .
pv2 .
pv3 .
pvp .

\ swap arenas
pvarena.swap
pvp .
pvarena .
pvarena 10 - 5 dump \ show the new arena
pvarena.dormant 10 - 5 dump \ show the old arena