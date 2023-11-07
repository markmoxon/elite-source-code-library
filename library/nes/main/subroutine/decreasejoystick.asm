\ ******************************************************************************
\
\       Name: DecreaseJoystick
\       Type: Subroutine
\   Category: Controllers
\    Summary: Decrease a joystick value by a specific amount, jumping straight
\             to the indicator centre if we decrease from the right-hand side
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
\ Other entry points:
\
\   decj2               Return a value of X = 128, for the centre of the
\                       indicator
\
\ ******************************************************************************

.DecreaseJoystick

 TXA                    \ Set X = X - joystickDelta
 SEC
 SBC joystickDelta
 TAX

 BCS decj1              \ If the subtraction didn't underflow, jump to decj1 to
                        \ skip the following instruction

 LDX #1                 \ Set X = 1 so X doesn't get smaller than 1 (so we can't
                        \ go past the left end of the indicator)

.decj1

 BPL decj3              \ If X < 127 then the decreased value is in the
                        \ left-hand side of the indicator, so jump to decj3 to
                        \ return from the subroutine

                        \ If we get here then the decreased value is still in
                        \ the right-hand side of the indicator, so we return a
                        \ value of 128, for the centre of the indicator

.decj2

 LDX #128               \ Set X = 128 to jump to indicator to the centre of the
                        \ indicator, so increasing or decreasing a value towards
                        \ the centre of the indicator immediately jumps to the
                        \ middle point of the indicator

.decj3

 RTS                    \ Return from the subroutine

