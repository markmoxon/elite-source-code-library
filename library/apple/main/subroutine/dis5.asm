\ ******************************************************************************
\
\       Name: DIS5
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the roll or pitch indicator on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The indicator number:
\
\                         * 1 = Roll indicator
\
\                         * 2 = Pitch indicator
\
\   A                   The magnitude of the pitch or roll, in the range 0 to 15
\                       (for roll) or 0 to 16 (for pitch)
\
\   N flag              The sign of the magnitude in A
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is incremented to the next indicator number
\
\ ******************************************************************************

.DIS5

 BPL DI9                \ If the angle whose magnitude in A is negative, negate
 EOR #&FF               \ A using two's complement, so A is now in the range
 CLC                    \ -15 to +15 (for roll) or -16 to +16 (for pitch)
 ADC #1

.DI9

 INY                    \ Increment Y to point to the next indicator, ready for
                        \ the next indicator to be drawn

                        \ If we have already drawn this indicator in a previous
                        \ iteration of the main loop, then we will have stored
                        \ the indicator value in the dials table, so we now
                        \ check this to see whether we need to update the
                        \ indicator
                        \
                        \ If this is the first time we have drawn this indicator
                        \ then the value in dials will be zero, to indicate that
                        \ no bar has yet been drawn
                        \
                        \ Note that as we just incremented Y, we need to fetch
                        \ the value for this indicator from dials-1 + Y

 CLC                    \ Set A = A + 224
 ADC #224               \
                        \ The x-coordinate of the centre point of the indicator
                        \ is 224, so this gives us the x-coordinate of the bar
                        \ that we need to draw to represent the angle in A

 CMP dials-1,Y          \ If the indicator value in A matches the previous value
 BEQ DIR1               \ for this indicator in dials, jump to DIR1 to return
                        \ from the subroutine without updating the indicator (as
                        \ DIR1 contains an RTS)

 PHA                    \ Store the indicator value in A on the stack, so we can
                        \ retrieve it below

 LDA dials-1,Y          \ If the previous value is zero, then skip the following
 BEQ P%+5               \ instruction as there is currently no bar to be removed

 JSR DIS6               \ Call DIS6 below to draw the indicator bar using its
                        \ previous value, which will remove it from the screen
                        \ as we draw indicators using EOR logic

 PLA                    \ Retrieve the new indicator value from the stack and
 STA dials-1,Y          \ store it in the dials table, for use the next time
                        \ the indicator is drawn

.DIS6

 STA X1                 \ Set X1 to the indicator value (which we converted into
                        \ the x-coordinate of the bar earlier)

 LDA dialY-1,Y          \ Set Y1 to the screen y-coordinate of the indicator
 STA Y1                 \ from the dialY table (so this is the y-coordinate of
                        \ the top line of the indicator)

 CLC                    \ Set Y2 = Y1 + 6, so we draw a vertical bar of six
 ADC #6                 \ pixels in height
 STA Y2

 JMP VLOIN              \ Jump to VLOIN to draw the indicator bar as a vertical
                        \ line from (X1, Y1) to (X1, Y2), returning from the
                        \ subroutine using a tail call

