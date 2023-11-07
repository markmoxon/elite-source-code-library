\ ******************************************************************************
\
\       Name: SetControllerPast
\       Type: Subroutine
\   Category: Controllers
\    Summary: Set the controller history variables to the values from four
\             VBlanks ago
\  Deep dive: Bolting NES controllers onto the key logger
\
\ ******************************************************************************

.SetControllerPast

 LDA controller1B       \ If the B button is being held down, jump to past1 to
 BNE past1              \ zero the controller history variables, as we don't
                        \ need the controller history for the icon bar movement
                        \ (which is done by holding down the B button while
                        \ using the left and right buttons)

 LDA controller1Left    \ Set the high nibble of the left button history
 ASL A                  \ variable to bits 0 to 3 of controller1Left, so it
 ASL A                  \ contains the controller values from four VBlanks ago
 ASL A
 ASL A
 STA controller1Left03

 LDA controller1Right   \ Set the high nibble of the right button history
 ASL A                  \ variable to bits 0 to 3 of controller1Right, so it
 ASL A                  \ contains the controller values from four VBlanks ago
 ASL A
 ASL A
 STA controller1Right03

 RTS                    \ Return from the subroutine

.past1

 LDA #0                 \ Zero the controller history variables as we don't need
 STA controller1Left03  \ them for moving the icon bar pointer
 STA controller1Right03

 RTS                    \ Return from the subroutine

