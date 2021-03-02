\ ******************************************************************************
\
\       Name: ee3
\       Type: Subroutine
\   Category: Text
\    Summary: Print the hyperspace countdown in the top-left of the screen
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION \ Comment
\ Print the 8-bit number in X at text location (0, 1). Print the number to
ELIF _DISC_VERSION OR _6502SP_VERSION
\ Print the 8-bit number in X at text location (1, 1). Print the number to
ENDIF
\ 5 digits, left-padding with spaces for numbers with fewer than 3 digits (so
\ numbers < 10000 are right-aligned), with no decimal point.
\
\ Arguments:
\
\   X                   The number to print
\
\ ******************************************************************************

.ee3

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is red in the space view

ENDIF

IF _CASSETTE_VERSION \ Feature

 LDY #1                 \ Move the text cursor to row 1
 STY YC

 DEY                    \ Decrement Y to 0 for the high byte in pr6

 STY XC                 \ Move the text cursor to column 0

ELIF _DISC_VERSION

 LDY #1                 \ Move the text cursor to column 1
 STY XC

 STY YC                 \ Move the text cursor to row 1

 DEY                    \ Decrement Y to 0 for the high byte in pr6

ELIF _6502SP_VERSION

 LDA #1                 \ Move the text cursor to column 1 on row 1
 JSR DOXC
 JSR DOYC

 LDY #0                 \ Set Y = 0 for the high byte in pr6

ENDIF

                        \ Fall through into pr6 to print X to 5 digits, as the
                        \ high byte in Y is 0

