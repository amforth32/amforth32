/* 

    PVALUES

The pvalue subsystem provides persistency for system values that require it. Persistency
is achieved by writing a rolling log of update records into flash backed PVFLASH memory region.
When the system restarts the log is replayed to initialize the pvalues to the latest recorded state (pv.init).
Main goals of the implementation were:
 * simplicity - over optimal but more complex solution
 * robustness - ability to recover from unexpected resets without losing persisted state

To be able to compact the log when PVFLASH fills up, the region is divided into two equal size arenas,
only one of which is active at a time (pvarena). When the arena fills up, compact and swap operation
is triggered automatically on next record write attempt (pvarena.swap). If the swap doesn't complete
for whatever reason, it will be attempted again, until it finishes successfully.
It can also be invoked explicitly at any time.

The log entries (pvalue records) are 2 words:
1) ID: identifies which pvalue the record belongs to, the pvalue RAM address is used as the ID
2) VALUE: the new value of the pvalue

First record of the arena is used to capture arena state. The two words have following meaning
1) COUNTER: starts at 0 and is incremented for each new arena activation after the swap
2) DIRTY: pvflash.erased for blank dormant arena, ~pvflash.erased for arena that has been written into

COUNTER has its MSB always set to make it distinct from usual RAM addresses. It counts up to pvflash.erased (usually -1)
so there needs to be enough room for all the swaps (normally shouldn't be a problem, given the usual flash memory lifetime).
Arena record is the last thing written into the new arena during a swap. This allows detecting unfinished swaps,
a swap hasn't been successful until the COUNTER is written.
The only other time when arena record is written is during the very first initialization (first-boot).

Following forth code documents the implementation. It is transpiled into ITC below.

\ Updating a pvalue means writing a new pvalue record in the current pvarena,
\ and then updating the corresponding RAM cell with the same value.
: pv.store ( x addr -- ) \ update pvalue identified by RAM addr to value x
    \ if pvarena.size is 0 do just the RAM update, skip the rest
    pvarena.size dup 0= if ! exit then
    \ check that there is room in the current arena, compact and swap arenas otherwise
    pvarena + pvp <= if pvarena.swap then
    \ write pvalue RAM address as the record ID, then the value
	2dup pvp 2!pvf
    pvp cell+ cell+ to pvp \ increment pvp
    ! \ update ram
;

: vaddr ( "name" -- addr ) \ RAM address of value "name"
    ' >body @ ;

\ Arena state is stored in the first record of the arena.
\ First cell is a counter with MSB set (so that it doesn't match any real RAM address).
\ Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
\ Current arena is the one with higher ID that is not -1.
: pvarena.init ( -- ) \ set pvarena to whichever arena should be current
    pvarena1 @ dup pvflash.erased <> if \ is arena1 dormant? (ID == pvlfash.erased)
        pvarena2 @ dup pvflash.erased <> if \ is arena2 dormant?
            \ (a1id a2id) higher ID wins
            < if pvarena2 to pvarena
            else pvarena1 to pvarena
            then
        else \ arena2 is dormant ( a1id pvlfash.erased )
            pvarena1 to pvarena
            2drop \ unused arena IDs
        then
    else \ arena1 is dormant ( pvlfash.erased )
        pvarena2 @ pvflash.erased <> if \ is arena2 dormant?
            pvarena2 to pvarena
        else \ arena2 is dormant
            \ both arenas are blank, initialize arena1 and use it.
            pvflash.erased invert $80000000 pvarena1 2!pvf
            pvarena1 to pvarena
        then
        drop \ unused arena1 ID
    then ;

\ The pvalues must be initialized with their default values first (like any values),
\ then this will replay all the pvalue records, ending up with the latest persisted state.
: pv.init ( -- ) \ replay pvarena records, set pvp
    \ if pvarena.size is 0 do nothing
    pvarena.size 0= if exit then
    pvarena.init \ initialize pvarena
    pvarena cell+ cell+ \ skip the arena record
    begin
    dup @ dup pvflash.erased <> while \ if record id is not all 1 bits, i.e. -1
        \ ( pvp pv-ram )
        swap cell+ tuck @ \ ( pvp+ pv-ram [pvp+] )
        swap ! \ update pvalue in RAM ( pvp+ )
        cell+ \ ( pvp++ )
    repeat
    \ ( pvp++ -1 )
    drop to pvp \ update pvp
;

: pvarena.dormant ( -- addr ) \ return address of the other arena
    pvarena1 pvarena = if pvarena2 else pvarena1 then
;

: pvarena.erase ( addr -- ) \ erase arena at addr from the end
\ erase the first block last in case the erase operation is interrupted
    dup pvarena.size + pvflash.page -
    begin 2dup <= while
        dup pvflash.erase
        pvflash.page -
    repeat
    2drop
;

\ helper for pv.do that follows
:noname ( xt ffa -- xt f ) 
    dup @ flag.pvalue and if
        \ need to stow the xt away while executing it
        \ so that the word can work with the underlying stack
        \ afterwards restore the xt to the stack and return the result on top
        ffa2cfa swap dup >r execute r> swap
    else drop true then
;

 \ this definition must follow the noname above, assumes its xt on the stack (see literal)
: pv.do ( xt -- ) \ run xt ( pv-xt -- f ) for every pvalue in forth-wordlist
    literal forth-wordlist traverse-wordlist
    drop \ drop the xt at the end
;


\ used to prepare dormant arena for arena swap (this should be noname)
: pv.write ( awp ffa - awp++ f ) \ write pvalue record at awp, advance awp
	swap dup rot \ ( awp awp ffa )
    >body @ dup @ swap rot \ ( awp [pv-ram] pv-ram awp )
    2!pvf \ write the record
    cell+ cell+ \ ( awp++ )
    true
;

\ second cell of the arena record is written first to mark it dirty
\ if arena is dirty it is erased completely first (erase the first block last in case the erase operation is interrupted)
\ first cell of arena record is written last, with ID +1 of the active arena,
\ this marks the arena complete and active.
\ it should be always possible to rerun a swap if it fails to complete for whatever reason (e.g. reset)
\ it can also be run explicitly, doesn't have to be invoked automatically by pv.store
: pvarena.swap ( -- ) \ write fresh pvalues into the dormant arena and swap arenas
    pvarena.dormant
    \ check if it needs to be erased, was the first pvalue record written?
    dup cell+ cell+ dup @ pvflash.erased <> if over pvarena.erase then
    \ ( arena arena++ )
    \ write fresh record for each persistent value in forth-wordlist
    ['] pv.write pv.do
    swap \ swap the arena pointers ( awp arena )
    \ write arena record, this MUST happen last
    dup pvflash.erased invert swap ( awp arena dirty arena )
	pvarena @ 1+ swap ( awp arena dirty id arena )
	2!pvf
    \ swap arenas ( awp arena )
    pvarena swap ( awp old-arena new-arena )
    to pvarena swap \ set pvarena
    to pvp \ set pvp
    pvarena.erase \ erase old arena
;
*/

/* pvalue memory constants */

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena2_lower /* address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvarena.size", PVARENA_SIZE, pvarena.size /* size of pvalue arena */
END PVARENA_SIZE

CONSTANT "pvflash.page", PVFLASH_PAGE, pvflash.page /* size of PV flash page (erase size) */
END PVFLASH_PAGE

CONSTANT "pvflash.cell", PVFLASH_CELL, pvflash.cell /* size of PV flash cell (write size) */
END PVFLASH_CELL

CONSTANT "pvflash.erased", PVFLASH_ERASED, pvflash.erased /* value of a cell in erased flash */
END PVFLASH_ERASED

CONSTANT "pvflash.size", PVFLASH_SIZE, pvflash.size /* total size of PV flash */
END PVFLASH_SIZE

CONSTANT "pvflash.start", PVFLASH_START, pvflash.start /* start address of PV flash */
END PVFLASH_START

/* following deferred words are PVFLASH primitives that need to be implemented by the MCU */

DEFER "2!pvf", 2STORE_PVF, XT_TILDE2STORE_PVF /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
END 2STORE_PVF

DEFER "pvflash.erase", PVFLASH_ERASE, XT_TILDEPVFLASH_ERASE /* ( addr -- ) erase PV flash page at addr */
END PVFLASH_ERASE

/* pvalue runtime values, must be initialized by pv.init */

VALUE "pvp", PVP, 0 /* ( -- addr ) address of the next free cell in active arena */
END PVP

VALUE "pvarena", PVARENA, 0 /* ( -- addr ) start address of the active arena */
END PVARENA

# ----------------------------------------------------------------------

COLON "pv.store", PV_STORE /* ( x addr -- ) update pvalue identified by RAM addr to value x */
/*  Updating a pvalue means writing a new pvalue record in the current pvarena,
    and then updating the corresponding RAM cell with the same value.
    If current arena is full run pvarena.swap first. */
    /* if pvarena.size is 0 do just the RAM update, skip the rest */
    .word XT_PVARENA_SIZE, XT_DUP, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
        .word XT_STORE, XT_EXIT
1:
    /*  check that there is room in the current arena,
        compact and swap arenas otherwise */
	.word XT_PVARENA
	.word XT_PLUS
	.word XT_PVP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH, 2f
	    .word XT_PVARENA_SWAP
 2: /* then */
    /* ( x addr ) write pvalue RAM address as the record ID */
	.word XT_2DUP, XT_PVP, XT_2STORE_PVF
    /* ( x addr ) update PVP */
	.word XT_PVP, XT_CELLPLUS, XT_CELLPLUS, XT_DOTO, XT_PVP
    /* ( x addr ) update RAM */
	.word XT_STORE
	.word XT_EXIT
END PV_STORE

# ----------------------------------------------------------------------

COLON "vaddr", VADDR /* ( "name" -- addr ) RAM address of value "name" */
	.word XT_TICK
	.word XT_TO_BODY
	.word XT_FETCH
	.word XT_EXIT
END VADDR

# ----------------------------------------------------------------------

COLON "pvarena.init", PVARENA_INIT /* ( -- ) set pvarena to whichever arena should be current */
/*  Arena state is stored in the first record of the arena.
    First cell is a counter with MSB set (so that it doesn't match any real RAM address).
    Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
    Current arena is the one with higher ID that is not -1. */
    /* if pvarena.size is 0 do nothing, just exit */
    .word XT_PVARENA_SIZE, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
        .word XT_EXIT
1:
	.word XT_PVARENA1
	.word XT_FETCH
	.word XT_DUP
	.word XT_PVFLASH_ERASED, XT_NOTEQUAL
	.word XT_DOCONDBRANCH,PVARENA_INIT_0001
	.word XT_PVARENA2
	.word XT_FETCH
	.word XT_DUP
	.word XT_PVFLASH_ERASED, XT_NOTEQUAL
	.word XT_DOCONDBRANCH,PVARENA_INIT_0002
	.word XT_LESS
	.word XT_DOCONDBRANCH,PVARENA_INIT_0003
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENA_INIT_0004
PVARENA_INIT_0003: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
PVARENA_INIT_0004: # then
	.word XT_DOBRANCH,PVARENA_INIT_0005
PVARENA_INIT_0002: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_2DROP
PVARENA_INIT_0005: # then
	.word XT_DOBRANCH,PVARENA_INIT_0006
PVARENA_INIT_0001: /* else \ arena1 is dormant */
	.word XT_PVARENA2
	.word XT_FETCH
	.word XT_PVFLASH_ERASED, XT_NOTEQUAL
	.word XT_DOCONDBRANCH,PVARENA_INIT_0007
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENA_INIT_0008
PVARENA_INIT_0007: # else
    /* both arenas are blank, initialize arena1 and use it. */
	.word XT_PVFLASH_ERASED, XT_INVERT
	.word XT_DOLITERAL, 0x80000000
	.word XT_PVARENA1
	.word XT_2STORE_PVF
	.word XT_PVARENA1, XT_DOTO, XT_PVARENA
PVARENA_INIT_0008: # then
	.word XT_DROP
PVARENA_INIT_0006: # then
	.word XT_EXIT
END PVARENA_INIT

# ----------------------------------------------------------------------

COLON "pv.init", PV_INIT /* ( -- ) replay pvarena records, set pvp */
/*  The pvalues must be initialized with their default values first (like any values),
    then this will replay all the pvalue records, ending up with the latest persisted state. */
	.word XT_PVARENA_INIT
	.word XT_PVARENA
	.word XT_CELLPLUS
	.word XT_CELLPLUS
PV_INIT_0001: # begin
	.word XT_DUP
	.word XT_FETCH
	.word XT_DUP
	.word XT_PVFLASH_ERASED, XT_NOTEQUAL
	.word XT_DOCONDBRANCH,PV_INIT_0002
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_TUCK
	.word XT_FETCH
	.word XT_SWAP
	.word XT_STORE
	.word XT_CELLPLUS
	.word XT_DOBRANCH,PV_INIT_0001
PV_INIT_0002:
	.word XT_DROP
	.word XT_DOTO
	.word XT_PVP
	.word XT_EXIT
END PV_INIT

# ----------------------------------------------------------------------

COLON "pvarena.dormant", PVARENA_DORMANT /* ( -- addr ) start address of the dormant arena */
	.word XT_PVARENA1
	.word XT_PVARENA
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,PVARENA_DORMANT_0001
	.word XT_PVARENA2
	.word XT_DOBRANCH,PVARENA_DORMANT_0002
PVARENA_DORMANT_0001: # else
	.word XT_PVARENA1
PVARENA_DORMANT_0002: # then
	.word XT_EXIT
END PVARENA_DORMANT

# ----------------------------------------------------------------------

COLON "pvarena.erase", PVARENA_ERASE /* ( addr -- ) erase arena at addr */
/* erase the first block last in case the erase operation is interrupted */
	.word XT_DUP
	.word XT_PVARENA_SIZE
	.word XT_PLUS
	.word XT_PVFLASH_PAGE
	.word XT_MINUS
PVARENA_ERASE_0001: # begin
	.word XT_2DUP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,PVARENA_ERASE_0002
	.word XT_DUP
	.word XT_PVFLASH_ERASE
	.word XT_PVFLASH_PAGE
	.word XT_MINUS
	.word XT_DOBRANCH,PVARENA_ERASE_0001
PVARENA_ERASE_0002:
	.word XT_2DROP
	.word XT_EXIT
END PVARENA_ERASE

# ----------------------------------------------------------------------

NONAME "pv.write", PV_WRITE /* ( awp ffa - awp++ f ) write pvalue record at awp, advance awp */
/*  Used to prepare dormant arena for arena swap */
	.word XT_SWAP, XT_DUP, XT_ROT /* ( awp awp ffa ) */
	.word XT_TO_BODY, XT_FETCH, XT_DUP, XT_FETCH, XT_SWAP, XT_ROT
	/* ( awp [pv-ram] pv-ram awp ) */
	.word XT_2STORE_PVF
	/* update awp */
	.word XT_CELLPLUS, XT_CELLPLUS
	.word XT_TRUE
	/* ( awp++ true ) */
	.word XT_EXIT
END PV_WRITE

# ----------------------------------------------------------------------

COLON "pvarena.swap", PVARENA_SWAP /* ( -- ) write fresh pvalues into the dormant arena and swap arenas */
/*  Second cell of the arena record is written first to mark it dirty.
    If arena is dirty it is erased completely first (erase the first block last in case the erase is interrupted.)
    First cell of arena record is written last, with ID +1 of the active arena,
    this marks the arena complete and active.
    It should be always possible to rerun a swap if it fails to complete for whatever reason (e.g. reset)
    It can also be run explicitly, doesn't have to be invoked automatically by pv.store. */
	.word XT_PVARENA_DORMANT
	/* check if it needs to be erased, was the first pvalue record written? */
	.word XT_DUP, XT_CELLPLUS, XT_CELLPLUS, XT_DUP, XT_FETCH, XT_PVFLASH_ERASED
	/* ( arena arena++ [arena++] erased ) */
	.word XT_NOTEQUAL, XT_DOCONDBRANCH, 1f
		.word XT_OVER, XT_PVARENA_ERASE
1:	/* then */
	/* ( arena arena++ ) write fresh record for each persistent value in forth-wordlist */
	.word XT_DOLITERAL, XT_PV_WRITE, XT_PV_DO
	/* ( arena awp ) awp is arena write pointer, next free cell */
	/* write arena record, this MUST happen last */
	.word XT_SWAP, XT_DUP, XT_PVFLASH_ERASED, XT_INVERT, XT_SWAP
	/* ( awp arena dirty arena ) */
	.word XT_PVARENA, XT_FETCH, XT_1PLUS, XT_SWAP
	/* ( awp arena dirty id arena ) */
	.word XT_2STORE_PVF
	/* update arena pointers */
	.word XT_PVARENA, XT_SWAP
	/* ( awp old-arena new-arena ) */
	.word XT_DOTO, XT_PVARENA /* set pvarena */
	.word XT_SWAP, XT_DOTO, XT_PVP /* set pvp */
	.word XT_PVARENA_ERASE /* ( old-arena ) erase old arena */
	.word XT_EXIT
END PVARENA_SWAP

NONAME "pv.do1", PV_DO1 /* ( xt ffa -- xt f ) helper for pv.do */
/*  :noname ( xt ffa -- xt f ) \ helper for pv.do
    dup @ flag.pvalue and if
        \ need to stow the xt away while executing it
        \ so that it can work with the underlying stack,
        \ afterwards restore the xt to the stack and return the boolean on top
        ffa2cfa swap dup >r execute r> swap
    else drop true then
; */
	.word XT_DUP
	.word XT_FETCH
    .word XT_FLAGDOTPVALUE
	.word XT_AND
	.word XT_DOCONDBRANCH, 1f
	.word XT_FFA2CFA
	.word XT_SWAP, XT_DUP, XT_TO_R
	.word XT_EXECUTE
    .word XT_R_FROM, XT_SWAP
	.word XT_DOBRANCH, 2f
1: # else
	.word XT_DROP
	.word XT_TRUE
2: # then
	.word XT_EXIT
END PV_DO1

COLON "pv.do", PV_DO /* ( xt -- ) run xt ( pv-xt -- f ) for every pvalue in forth-wordlist */
/*  \ this definition must follow the noname above, assumes its xt on the stack.
    : pv.do ( xt -- ) \ run xt ( pv-xt -- f ) for every pvalue in forth-wordlist
    literal forth-wordlist traverse-wordlist
    drop \ drop the xt at the end
; */
    .word XT_DOLITERAL, XT_PV_DO1
    .word XT_FORTH_WORDLIST
	.word XT_TRAVERSEWORDLIST
    .word XT_DROP
    .word XT_EXIT
END PV_DO

COLON "pv.reset-hard", PV_RESET_HARD /* ( -- ) erase entire pvflash and reinitialize pvalue system */
/* WARNING: All pvalue records will be wiped, they will reset to their default values on next restart.
	However you may want to do this before uploading a new build of AmForth to the board.
	You do not want pv.init replaying invalid records with wrong RAM addresses,
	which is likely if pvalues moved around in the new build. */
	.word XT_PVARENA_DORMANT, XT_PVFLASH_ERASE
	.word XT_PVARENA, XT_PVFLASH_ERASE
	.word XT_PV_INIT
	.word XT_EXIT
END PV_RESET_HARD
