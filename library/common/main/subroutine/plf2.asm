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

IF _CASSETTE_VERSION

 LDX #6                 \ Set the text cursor to column 6
 STX XC

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA #6
 JMP DOXC

ENDIF

