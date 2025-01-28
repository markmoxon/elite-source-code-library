\ ******************************************************************************
\
\       Name: DIS1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update a bar-based indicator on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ The range of values shown on the indicator depends on which entry point is
\ called. For the default entry point of DIS1, the range is 0-255 (as the value
\ passed in A is one byte), while for DIS2 the range is 0-31.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The value to be shown on the indicator (so the larger
\                       the value, the longer the bar)
\
\   Y                   The indicator number:
\
\                         *  0 = Speed indicator
\                         *  3 = Energy bank 4 (bottom)
\                         *  4 = Energy bank 3
\                         *  5 = Energy bank 2
\                         *  6 = Energy bank 1 (top)
\                         *  7 = Forward shield indicator
\                         *  8 = Aft shield indicator
\                         *  9 = Fuel level indicator
\                         * 10 = Altitude indicator
\                         * 11 = Cabin temperature indicator
\                         * 12 = Laser temperature indicator
\
\   K                   The screen x-coordinate of the left end of the indicator
\
\   K+2                 The colour we should use for dangerous values
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The value to be shown on the indicator, scaled to fit
\                       into the range 0 to 31
\
\   Y                   Y is incremented to the next indicator number
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DIS1+2              The range of the indicator is 0-63 (for the fuel
\                       indicator)
\
\   DIS2                The range of the indicator is 0-31 (for the fuel and
\                       energy bank indicators)
\
\   DIR1                Contains an RTS
\
\ ******************************************************************************

.DIS1

 LSR A                  \ Set A = A / 16, so A is 0-31
 LSR A
 LSR A

.DIS2

 CMP #32                \ Cap A to a maximum value of 31, so A is in the range
 BCC P%+4               \ 0 to 31
 LDA #31

 LDX dialc1,Y           \ Set X to the low-value colour for indicator Y from the
                        \ dialc1 table

 CMP dialle,Y           \ If A < dialle for indicator Y, then this is a low
 BCC DI3                \ value that is below the threshold for this indicator,
                        \ so jump to DI3 as we already have the correct colour

 LDX dialc2,Y           \ If we get here then A > dialle for indicator Y,
                        \ which is a high value that is on or above the
                        \ threshold for this indicator, so set X to the
                        \ high-value colour for indicator Y from the dialc2
                        \ table

.DI3

 CPX #&FF               \ If the colour in X is not &FF, jump to DI4
 BNE DI4

 LDX K+2                \ If the colour in X is &FF, set X = K + 2, so X is
                        \ either red, or flashing red-and-white if flashing
                        \ colours are configured

 CLC                    \ Clear the C flag (though this doesn't seem to have any
                        \ effect, as we do a comparison almost straight away
                        \ that will override the C flag)

.DI4

 INY                    \ Increment Y to point to the next indicator, ready for
                        \ the next indicator to be drawn

 PHA                    \ Store the indicator value in A on the stack, so we can
                        \ retrieve it below

                        \ If we have already drawn this indicator in a previous
                        \ iteration of the main loop, then we will have stored
                        \ the indicator value and colour in the dials and dialc
                        \ tables, so we now check these to see whether we need
                        \ to update the indicator
                        \
                        \ If this is the first time we have drawn this indicator
                        \ then the values in dials and dialc will be zero, to
                        \ indicate that no bar is shown
                        \
                        \ Note that as we just incremented Y, we need to fetch
                        \ the values for this indicator from dials-1 + Y and
                        \ dialc-1 + Y, for example

 CMP dials-1,Y          \ If the indicator value in A does not match the
 BNE DI6                \ previous value for this indicator in dials, jump to
                        \ DI6 to update the indicator

 TXA                    \ If the colour in X matches the previous colour in
 CMP dialc-1,Y          \ dialc, then both the value and the colour of this
 BEQ DI8                \ indicator are unchanged, so jump to DI8 to return
                        \ from the subroutine without drawing anything

.DI6

 TXA                    \ Store the new colour of the bar in the dialc table,
 LDX dialc-1,Y          \ for use the next time the indicator is drawn, and
 STA dialc-1,Y          \ set X to the previous colour

 LDA dials-1,Y          \ Set A to the previous value of this indicator from
                        \ the dials table

 JSR DIS7               \ Call DIS7 below to draw this indicator using its
                        \ previous value and colour, which will remove it from
                        \ the screen as we draw indicators using EOR logic

 LDX dialc-1,Y          \ Set X to the new colour for the indicator, which we
                        \ just stored in the dialc table

 PLA                    \ Retrieve the new indicator value from the stack and
 STA dials-1,Y          \ store it in the dials table, for use the next time
                        \ the indicator is drawn

.DIS7

                        \ We now draw the indicator with the colour in X and
                        \ the value in A

 STX COL                \ Set the drawing colour to X

 LDX dialY-1,Y          \ Set Y1 to the screen y-coordinate of the indicator
 STX Y1                 \ from the dialY table (so this is the y-coordinate of
                        \ the top line of the four-line indicator)

 LDX K                  \ Set X1 to K, so it contains the x-coordinate of the
 STX X1                 \ left end of the indicator

 CLC                    \ Set X2 = K + A, so it contains the x-coordinate of the
 ADC K                  \ right end of the indicator bar (as we want to draw a
 AND #%11111110         \ bar of length A pixels)
 STA X2                 \
                        \ We round this down to an even number to ensure that
                        \ the two-bit colour pattern fits exactly (though this
                        \ isn't strictly necessary as the HLOIN routine also
                        \ does this)

 JSR P%+3               \ Call MSBARS twice to draw four pixel lines to form the
 JMP MSBARS             \ indicator bar, returning from the subroutine using a
                        \ tail call

.DI8

 PLA                    \ Retrieve the indicator value from the stack so we can
                        \ return it in A

.DIR1

 RTS                    \ Return from the subroutine

