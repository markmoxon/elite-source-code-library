\ ******************************************************************************
\
\       Name: BRIS
\       Type: Subroutine
\   Category: Missions
\    Summary: Clear the screen, display "INCOMING MESSAGE" and wait for 2
\             seconds
\
\ ******************************************************************************

.BRIS

 LDA #216               \ Print extended token 216 ("{clear screen}{tab 6}{move
 JSR DETOK              \ to row 10, white, lower case}{white}{all caps}INCOMING
                        \ MESSAGE"

IF _NES_VERSION

 JSR DrawViewInNMI2     \ Hide all sprites and configure the NMI handler to draw
                        \ the view

ENDIF

 LDY #100               \ Delay for 100 vertical syncs (100/50 = 2 seconds) and
 JMP DELAY              \ return from the subroutine using a tail call

