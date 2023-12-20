\ ******************************************************************************
\
\       Name: PrintNameInMiddle
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print the commander name in the middle column using the highlight
\             font
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number in which to print the commander name in
\                       the middle column (0 to 7)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.PrintNameInMiddle

 LDX #2                 \ Set the font style to print in the highlight font
 STX fontStyle

 LDX #11                \ Move the text cursor to column 11, so we print the
 STX XC                 \ name in the middle column of the screen

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ after the following calculation

 ASL A                  \ Move the text cursor to row 6 + A * 2
 CLC                    \
 ADC #6                 \ So this is the text row for slot number A in the
 STA YC                 \ middle column of the screen

 PLA                    \ Restore the value of A that we stored on the stack

 JSR PrintCommanderName \ Print the commander name from the commander file in
                        \ BUF, along with the save count

 LDX #1                 \ Set the font style to print in the normal font
 STX fontStyle

 RTS                    \ Return from the subroutine

