\ ******************************************************************************
\
\       Name: pr6
\       Type: Subroutine
\   Category: Text
\    Summary: Print 16-bit number, left-padded to 5 digits, no point
\
\ ------------------------------------------------------------------------------
\
\ Print the 16-bit number in (Y X) to 5 digits, left-padding with spaces for
\ numbers with fewer than 3 digits (so numbers < 10000 are right-aligned),
\ with no decimal point.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The low byte of the number to print
\
\   Y                   The high byte of the number to print
\
\ ******************************************************************************

.pr6

 CLC                    \ Do not display a decimal point when printing

                        \ Fall through into pr5 to print X to 5 digits

