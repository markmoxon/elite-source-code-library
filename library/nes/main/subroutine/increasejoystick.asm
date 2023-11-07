\ ******************************************************************************
\
\       Name: IncreaseJoystick
\       Type: Subroutine
\   Category: Controllers
\    Summary: Increase a joystick value by a specific amount, jumping straight
\             to the indicator centre if we increase from the left-hand side
\  Deep dive: Bolting NES controllers onto the key logger
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The value (pitch or roll rate) to decrease
\
\   joystickDelta       The amount to decrease the value in X by
\
\ ******************************************************************************

.IncreaseJoystick

 TXA                    \ Set X = X + joystickDelta
 CLC
 ADC joystickDelta
 TAX

 BCC incj1              \ If the addition didn't overflow, jump to incj1 to skip
                        \ the following instruction

 LDX #255               \ Set X = 255 so X doesn't get larger than 255 (so we
                        \ can't go past the right end of the indicator)

.incj1

 BPL decj2              \ If X < 127 then the increased value is still in the
                        \ left-hand side of the indicator, so jump to decj2 to
                        \ return a value of 128, for the centre of the indicator

 RTS                    \ Return from the subroutine

