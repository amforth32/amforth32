\ From: John Hayes S1I
\ Subject: tester.fr
\ Date: Mon, 27 Nov 95 13:10:09 PST  

\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.1

\ modified for amforth by Matthias Trute 2007

\ SET THE FOLLOWING FLAG TO TRUE FOR MORE VERBOSE OUTPUT; THIS MAY
\ ALLOW YOU TO TELL WHICH TEST CAUSED YOUR SYSTEM TO HANG.
variable VERBOSE
   0 VERBOSE !

variable ACTUAL-DEPTH  \ STACK RECORD
variable START-DEPTH

: EMPTY-STACK	\ ( ... -- ) EMPTY STACK: HANDLES UNDERFLOWED STACK TOO.
    depth START-DEPTH @ < if
        depth START-DEPTH @ swap do 0 loop
    then
    depth START-DEPTH @ > if
        depth START-DEPTH @ do drop loop
    then
;

variable ACTUAL-DEPTH			\ STACK RECORD
variable ACTUAL-RESULTS 20 cells allot  \ reserve space in RAM

: ERROR		\ ( C-ADDR U -- ) DISPLAY AN ERROR MESSAGE
   itype
   \ FOLLOWED BY THE ACTUAL STACK STATE AFTER THE TEST
   40 emit space \ OPEN BRACKET
   ACTUAL-DEPTH @ START-DEPTH @ - \ RESULT COUNT
   dup 0> if
      1- 0 swap do \ PRINT RESULTS FROM THE END
         ACTUAL-RESULTS i cells + @ .
      -1 +loop
   then
   41 emit cr \ CLOSE BRACKET
	\ FOLLOWED BY THE LINE THAT HAD THE ERROR.
   source type cr			\ DISPLAY LINE CORRESPONDING TO ERROR
   EMPTY-STACK				\ THROW AWAY EVERY THING ELSE
;

: t{ \ ( -- ) SYNTACTIC SUGAR.
    depth START-DEPTH !
;

: -> \ ( ... -- ) RECORD DEPTH AND CONTENT OF STACK.
   depth dup ACTUAL-DEPTH !		\ RECORD DEPTH
   START-DEPTH @ > if		\ IF THERE IS SOMETHING ON STACK
       depth START-DEPTH @ - 0 do ACTUAL-RESULTS i cells + ! loop \ SAVE THEM
   then
;

: }t		\ ( ... -- ) COMPARE STACK (EXPECTED) CONTENTS WITH SAVED
   depth ACTUAL-DEPTH @ = if		\ IF DEPTHS MATCH
      depth START-DEPTH @ > if		\ IF THERE IS SOMETHING ON THE STACK
         depth START-DEPTH @ - 0 do	\ FOR EACH STACK ITEM
            ACTUAL-RESULTS i cells + @	\ COMPARE ACTUAL WITH EXPECTED
            <> if s" INCORRECT RESULTS: " ERROR leave then
         loop
      then
   else					\ DEPTH MISMATCH
      s" WRONG NUMBER OF RESULTS: " ERROR
   then
;

: TESTING	\ ( -- ) TALKING COMMENT.
   source VERBOSE @
   if dup >r type cr r> >in !
   else >in ! drop
   then ;

