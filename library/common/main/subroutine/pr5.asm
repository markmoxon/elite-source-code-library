\ ******************************************************************************
\
\       Name: pr5
\       Type: Subroutine
\   Category: Text
\    Summary: Print a 16-bit number, left-padded to 5 digits, and optional point
\
\ ------------------------------------------------------------------------------
\
\ Print the 16-bit number in (Y X) to 5 digits, left-padding with spaces for
\ numbers with fewer than 3 digits (so numbers < 10000 are right-aligned).
\ Optionally include a decimal point.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The low byte of the number to print
\
\   Y                   The high byte of the number to print
\
\   C flag              If set, include a decimal point
\
\ ******************************************************************************

.pr5

 LDA #5                 \ Set the number of digits to print to 5

 JMP TT11               \ Call TT11 to print (Y X) to 5 digits and return from
                        \ the subroutine using a tail call

