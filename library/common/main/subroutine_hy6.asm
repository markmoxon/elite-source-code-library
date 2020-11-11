\ ******************************************************************************
\
IF _CASSETTE_VERSION
\       Name: hy6
ELIF _6502SP_VERSION
\       Name: dockEd
ENDIF
\       Type: Subroutine
\   Category: Flight
\    Summary: Print a message to say no hyperspacing inside the station
\
\ ------------------------------------------------------------------------------
\
\ Print "Docked" at the bottom of the screen to indicate we can't hyperspace
\ when docked.
\
\ ******************************************************************************

IF _CASSETTE_VERSION

.hy6

ELIF _6502SP_VERSION

 .dockEd

ENDIF

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

IF _CASSETTE_VERSION

 LDA #15                \ Move the text cursor to column 15 (the middle of the
 STA XC                 \ screen), setting A to 15 at the same time for the
                        \ following call to TT27

 JMP TT27               \ Print recursive token 129 ("{switch to sentence case}
                        \ DOCKED") and return from the subroutine using a tail
                        \ call

ELIF _6502SP_VERSION

 LDA #15
 JSR DOXC
 LDA #RED
 JSR DOCOL
 LDA #205
 JMP DETOK

ENDIF

