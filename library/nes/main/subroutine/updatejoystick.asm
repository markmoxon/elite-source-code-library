\ ******************************************************************************
\
\       Name: UpdateJoystick
\       Type: Subroutine
\   Category: Controllers
\    Summary: Update the values of JSTX and JSTY with the values from the
\             controller
\
\ ******************************************************************************

.UpdateJoystick

 LDA QQ11a              \ If the old view in QQ11a is not the space view, then
 BNE SetControllerPast  \ jump to SetControllerPast to set the controller
                        \ history variables to the values from four VBlanks ago

 LDX JSTX               \ Set X to the current roll rate in JSTX

 LDA #8                 \ Set joystickDelta = 8, to use as the amount by which
 STA joystickDelta      \ we change the roll rate by for each button press

 LDY numberOfPilots     \ Set Y to numberOfPilots, which will be 0 if only one
                        \ pilot is configured, or 1 if two pilots are configured
                        \
                        \ As the rest of this routine updates the joystick based
                        \ on the values in controller1Right + Y etc., this means
                        \ that when the game is configured for two pilots, the
                        \ routine updates the joystick variables based on the
                        \ buttons being pressed on controller 2
                        \
                        \ In other words, when two pilots are configured,
                        \ controller 2 steers the ship while controller 1 looks
                        \ after the weaponry

 BNE joys1              \ If numberOfPilots = 1 then the game is configured for
                        \ two pilots, so skip the following so that holding down
                        \ the B button on controller 1 doesn't stop controller 2
                        \ from updating the flight controls

 LDA controller1B       \ If the B button is being pressed on controller 1 then
 BMI joys10             \ the arrow should be used to control the icon bar and
                        \ ship speed, rather than the ship's steering, so jump
                        \ to joys10 to return from the subroutine

.joys1

 LDA controller1Right,Y \ If the right button is not being pressed, jump to
 BPL joys2              \ joys2 to skip the following instruction

 JSR DecreaseJoystick   \ The right button is being held down, so decrease the
                        \ current roll rate in X by joystickDelta

.joys2

 LDA controller1Left,Y  \ If the left button is not being pressed, jump to joys3
 BPL joys3              \ to skip the following instruction

 JSR IncreaseJoystick   \ The left button is being held down, so increase the
                        \ current roll rate in X by joystickDelta

.joys3

 STX JSTX               \ Store the updated roll rate in JSTX

 TYA                    \ If Y is non-zero then the game is configured for two
 BNE joys4              \ pilots, so jump to joys4... though as this is the very
                        \ next line, this has no effect

.joys4

 LDA #4                 \ Set joystickDelta = 4, to use as the amount by which
 STA joystickDelta      \ we change the pitch rate by for each button press

 LDX JSTY               \ Set X to the current pitch rate in JSTY

 LDA JSTGY              \ If JSTGY is &FF then the game is configured to reverse
 BMI joys8              \ the controller y-axis, so jump to joys8 to change the
                        \ pitch value in the opposite direction

 LDA controller1Down,Y  \ If the down button is not being pressed, jump to joys5
 BPL joys5              \ to skip the following instruction

 JSR DecreaseJoystick   \ The down button is being held down, so decrease the
                        \ current pitch rate in X by joystickDelta

.joys5

 LDA controller1Up,Y    \ If the up button is not being pressed, jump to joys7
 BPL joys7              \ to skip the following instruction

.joys6

 JSR IncreaseJoystick   \ The up button is being held down, so increase the
                        \ current pitch rate in X by joystickDelta

.joys7

 STX JSTY               \ Store the updated pitch rate in JSTY

 RTS                    \ Return from the subroutine

.joys8

 LDA controller1Up,Y    \ If the up button is not being pressed, jump to joys9
 BPL joys9              \ to skip the following instruction

 JSR DecreaseJoystick   \ The up button is being held down, so decrease the
                        \ current pitch rate in X by joystickDelta (as the game
                        \ is configured to reverse the joystick Y channel)

.joys9

 LDA controller1Down,Y  \ If the down button is being pressed, jump to joys6 to
 BMI joys6              \ increase the current pitch rate in X by joystickDelta
                        \ (as the game is configured to reverse the joystick Y
                        \ channel)

 STX JSTY               \ Store the updated pitch rate in JSTY

 RTS                    \ Return from the subroutine

.joys10

 RTS                    \ Return from the subroutine

