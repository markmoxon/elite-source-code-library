\ ******************************************************************************
\
\       Name: AllowJoystick
\       Type: Subroutine
\   Category: Loader
\    Summary: An unused routine to check the joysticks and configure the title
\             screen to check for the joystick fire button
\
\ ******************************************************************************

.AllowJoystick

 LDA #0                 \ Set fireButtonMask to 0 to prevent the joystick fire
 STA fireButtonMask     \ button from being able to select joysticks on the
                        \ title screen

 LDA &C064              \ Set A to the value of the soft switch containing the
                        \ status of the joystick 0 x-axis (GC0)

 CMP #&FF               \ If it is not &FF then jump to joys1 to start the game
 BNE joys1              \ with the fire button disabled

 LDA &C065              \ Set A to the value of the soft switch containing the
                        \ status of the joystick 0 y-axis (GC1)

 CMP #&FF               \ If it is not &FF then jump to joys1 to start the game
 BNE joys1              \ with the fire button disabled

 LDA &C066              \ Set A to the value of the soft switch containing the
                        \ status of the joystick 1 x-axis (GC2)

 CMP #&FF               \ If it is not &FF then jump to joys1 to start the game
 BNE joys1              \ with the fire button disabled

 LDA &C067              \ Set A to the value of the soft switch containing the
                        \ status of the joystick 1 y-axis (GC3)

 CMP #&FF               \ If it is not &FF then jump to joys1 to start the game
 BNE joys1              \ with the fire button disabled

                        \ If we get here then all four joystick soft switches
                        \ are returning &FF

 LDA #&FF               \ Set fireButtonMask to &FF to allow the joystick fire
 STA fireButtonMask     \ button to select joysticks on the title screen

.joys1

 JMP startGame          \ Jump to startGame to start the game

