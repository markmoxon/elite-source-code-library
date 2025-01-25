\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left, so indicator NOMSL is the leftmost
\                       indicator)
\
\   Y                   The new colour of the missile indicator:
\
\                         * #BLACK = black (no missile)
\
\                         * #RED = red (armed and locked)
\
\                         * #WHITE = white (armed)
\
\                         * #GREEN = green (disarmed)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\   A                   The value of Y when the subroutine was called
\
\ ******************************************************************************

.MSBAR

 TYA                    \ Store the new indicator colour in Y on the stack so we
 PHA                    \ can retrieve it after the call to MSBAR2

 JSR MSBAR2             \ Call MSBAR2 below to draw this indicator using its
                        \ previous value and colour, which will remove it from
                        \ the screen as we draw indicators using EOR logic

 PLA                    \ Retrieve the new indicator colour from the stack and
 STA mscol-1,X          \ store it in the mscol table, for use the next time
                        \ the indicator is drawn
                        \
                        \ We subtract 1 as the indicator number is in the range
                        \ 1 to NOMSL (i.e. 1 to 4 if we have four missiles
                        \ fitted)

.MSBAR2

 LDA mscol-1,X          \ Set A to the previous colour of this indicator from
                        \ the mscol table

 BEQ coolkey            \ If the previous colour is the same as the new colour,
                        \ jump to coolkey to clear the C flag and return from
                        \ the subroutine, as we do not need to redraw the
                        \ indicator

 STA COL                \ Set the drawing colour to A

 LDA msloc-1,X          \ Set X1 to the x-coordinate for indicator X, which we
 STA X1                 \ fetch from the msloc table

 CLC                    \ Set X1 = X2 + 6
 ADC #6                 \
 STA X2                 \ So the indicator is six pixels across

 TXA                    \ Store the indicator number in X on the stack so we can
 PHA                    \ retrieve it after the calls to MSBARS

 LDA #184               \ Set Y1 = 184, the y-coordinate of the top line of the
 STA Y1                 \ indicators

 JSR MSBARS             \ Call MSBARS twice to draw four pixel lines to form the
 JSR MSBARS             \ missile indicator, drawing from top to bottom

 PLA                    \ Restore the indicator number from the stack into X so
 TAX                    \ it is preserved

 TYA                    \ Set A to the value of Y when we called this routine,
                        \ so we can return it from the subroutine

 LDY #0                 \ Set Y = 0, so we can return it from the subroutine

 RTS                    \ Return from the subroutine

