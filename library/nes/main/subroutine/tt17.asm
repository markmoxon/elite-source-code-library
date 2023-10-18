\ ******************************************************************************
\
\       Name: TT17
\       Type: Subroutine
\   Category: Controllers
\    Summary: Scan the key logger for the directional pad buttons
\
\ ------------------------------------------------------------------------------
\
\ X and Y are integers between -1 and +1 depending on which buttons are pressed.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Returns:
\
\   A                   The button number, icon bar button was chosen
\
\   X                   Change in the x-coordinate according to the directional
\                       keys being pressed on controller 1
\
\   Y                   Change in the y-coordinate according to the directional
\                       keys being pressed on controller 1
\
\ ******************************************************************************

.TT17

 LDA QQ11               \ If this is not the space view, jump to dpad1 to read
 BNE dpad1              \ the directional pad on controller 1

 JSR DOKEY              \ This is the space view, so populate the key logger
                        \ and apply the docking computer manoeuvring code

 TXA                    \ Transfer the value of the key pressed from X to A

 RTS                    \ Return from the subroutine


.dpad1

 JSR DOKEY              \ Populate the key logger and apply the docking computer
                        \ manoeuvring code

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

 LDA controller1B       \ If the B button is being pressed on controller 1,
 BMI dpad5              \ jump to dpad5 to return from the subroutine, as the
                        \ arrow buttons act differently when B is also pressed

 LDA controller1Left03  \ If the left button on controller 1 was not being held
 BPL dpad2              \ down four VBlanks ago or for the three VBlanks before
                        \ that, jump to dpad2 to skip the following instruction

 DEX                    \ The left button has been held down for some time, so
                        \ decrement the x-delta in X

.dpad2

 LDA controller1Right03 \ If the right button on controller 1 was not being held
 BPL dpad3              \ down four VBlanks ago or for the three VBlanks before
                        \ that, jump to dpad3 to skip the following instruction

 INX                    \ The right button has been held down for some time, so
                        \ increment the x-delta in X

.dpad3

 LDA controller1Up      \ If the up button on controller 1 is not being pressed,
 BPL dpad4              \ jump to dpad4 to skip the following instruction

 INY                    \ The up button is being pressed, so increment the
                        \ y-delta in Y

.dpad4

 LDA controller1Down    \ If the down button on controller 1 is not being
 BPL dpad5              \ pressed, jump to dpad5 to skip the following
                        \ instruction

 DEY                    \ The down button is being pressed, so decrement the
                        \ y-delta in Y

.dpad5

 LDA iconBarKeyPress    \ Set A to the key logger entry for the icon bar button
                        \ press, to return from the subroutine

 RTS                    \ Return from the subroutine

