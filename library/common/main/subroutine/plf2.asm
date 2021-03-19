\ ******************************************************************************
\
\       Name: plf2
\       Type: Subroutine
\   Category: Text
\    Summary: Print text followed by a newline and indent of 6 characters
\
\ ------------------------------------------------------------------------------
\
\ Print a text token followed by a newline, and indent the next line to text
\ column 6.
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.plf2

 JSR plf                \ Print the text token in A followed by a newline

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDX #6                 \ Move the text cursor to column 6
 STX XC

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 LDA #6                 \ Move the text cursor to column 6
 STA XC

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA #6                 \ Move the text cursor to column 6 and return from the
 JMP DOXC               \ subroutine using a tail call

ENDIF

