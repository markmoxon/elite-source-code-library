\ ******************************************************************************
\
\       Name: TT17X
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the digital joystick for movement
\
\ ------------------------------------------------------------------------------
\
\ Scan the digital joystick for stick movement, and return the result as deltas
\ (changes) in x- and y-coordinates as follows:
\
\   * For joystick, X and Y are integers between -2 and +2 depending on how far
\     the stick has moved
\
\ Returns:
\
\   X                   Change in the x-coordinate according to the joystick
\                       movement, as an integer (see above)
\
\   Y                   Change in the y-coordinate according to the joystick
\                       movement, as an integer (see above)
\
\ ******************************************************************************

IF _COMPACT

.TT17X

 LDA VIA+&60            \ Read the User 6522 VIA, which is where the Master
                        \ Compact's digital joystick is mapped to. The pins go
                        \ low when the joystick connection is made, so we need
                        \ to check whether any of the following are zero:
                        \
                        \   PB0 = fire
                        \   PB1 = left
                        \   PB2 = down
                        \   PB3 = up
                        \   PB4 = right

 LSR A                  \ Shift the PB0 bit out, as we aren't interested in the
                        \ fire button in this routine

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

 LSR A                  \ If PB1 from the User VIA is set (left), skip the
 BCS P%+3               \ following

 DEX                    \ Set X = X - 1

 LSR A                  \ If PB2 from the User VIA is set (down), skip the
 BCS P%+3               \ following

 INY                    \ Set Y = Y + 1
                        \
                        \ Note that this is the opposite direction to the stick
                        \ direction, as moving the stick down should decrease Y.
                        \ To fix this, we flip this result below

 LSR A                  \ If PB3 from the User VIA is set (up), skip the
 BCS P%+3               \ following

 DEY                    \ Set Y = Y - 1
                        \
                        \ Note that this is the opposite direction to the stick
                        \ direction, as moving the stick up should increase Y.
                        \ To fix this, we flip this result below

 LSR A                  \ If PB4 from the User VIA is set (right), skip the
 BCS P%+3               \ following

 INX                    \ Set X = X + 1

 LDA JSTE               \ JSTE contains &FF if both joystick channels are
 BEQ TT171              \ reversed and 0 otherwise, so skip to L7F80 if the
                        \ joystick channels are not reversed

 TXA                    \ The X channel needs to be reversed, so negate the
 EOR #&FF               \ value in X, using two's complement
 CLC
 ADC #1
 TAX

.TT171

 LDA JSTE               \ Set A to &FF if both joystick channels are reversed
                        \ and 0 otherwise

 EOR JSTGY              \ JSTGY will be 0 if the game is configured to reverse
                        \ the joystick Y channel, &FF otherwise, so A will be
                        \ 0 if one of these is true:
                        \
                        \  * Both channels are normal and Y is reversed
                        \  * Both channels are reversed and Y is not
                        \
                        \ i.e. it will be 0 if the Y channel is configured to be
                        \ reversed

 BEQ TT17X-1            \ If the result in A is 0, return from the subroutine
                        \ (as TT17X-1 contain an RTS), as we already set the Y
                        \ value above to the opposite direction to the stick

                        \ If we get here, then the configuration settings are
                        \ not set to reverse the Y channel, so we now negate the
                        \ Y value, as we set Y above to the opposite direction
                        \ to the stick

 TYA                    \ The Y channel should be reversed, so negate the value
 EOR #&FF               \ in Y, using two's complement
 CLC
 ADC #1
 TAY

                        \ Fall through into ECMOF to return from the subroutine

ENDIF

