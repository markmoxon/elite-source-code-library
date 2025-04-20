\ ******************************************************************************
\
\       Name: TT11
\       Type: Subroutine
\   Category: Text
\    Summary: Print a 16-bit number, left-padded to n digits, and optional point
\
\ ------------------------------------------------------------------------------
\
\ Print the 16-bit number in (Y X) to a specific number of digits, left-padding
\ with spaces for numbers with fewer digits (so lower numbers will be right-
\ aligned). Optionally include a decimal point.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The low byte of the number to print
\
\   Y                   The high byte of the number to print
\
\   A                   The number of digits
\
\   C flag              If set, include a decimal point
\
\ ******************************************************************************

.TT11

 STA U                  \ We are going to use the BPRNT routine (below) to
                        \ print this number, so we store the number of digits
                        \ in U, as that's what BPRNT takes as an argument

 LDA #0                 \ BPRNT takes a 32-bit number in K to K+3, with the
 STA K                  \ most significant byte first (big-endian), so we set
 STA K+1                \ the two most significant bytes to zero (K and K+1)
 STY K+2                \ and store (Y X) in the least two significant bytes
 STX K+3                \ (K+2 and K+3), so we are going to print the 32-bit
                        \ number (0 0 Y X)

                        \ Finally we fall through into BPRNT to print out the
                        \ number in K to K+3, which now contains (Y X), to A
                        \ digits (as U = A), using the same C flag as when pr2
                        \ was called to control the decimal point

