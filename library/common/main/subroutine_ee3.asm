\ ******************************************************************************
\
\       Name: ee3
\       Type: Subroutine
\   Category: Text
\    Summary: Print the hyperspace countdown in the top-left of the screen
\
\ ------------------------------------------------------------------------------
\
\ Print the 8-bit number in X at text location (0, 1). Print the number to
\ 5 digits, left-padding with spaces for numbers with fewer than 3 digits (so
\ numbers < 10000 are right-aligned), with no decimal point.
\
\ Arguments:
\
\   X                   The number to print
\
\ ******************************************************************************

.ee3

IF _CASSETTE_VERSION

 LDY #1                 \ Set YC = 1 (first row)
 STY YC

 DEY                    \ Set XC = 0 (first character)
 STY XC

ELIF _6502SP_VERSION

 LDA #RED
 JSR DOCOL
 LDA #1
 JSR DOXC
 JSR DOYC
 LDY #0

ENDIF

                        \ Fall through into pr6 to print X to 5 digits

