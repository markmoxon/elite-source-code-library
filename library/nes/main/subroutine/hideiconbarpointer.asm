\ ******************************************************************************
\
\       Name: HideIconBarPointer
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Clear the icon bar choice and hide the icon bar pointer
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   hipo2               Clear the icon button choice and hide the icon bar
\                       pointer
\
\ ******************************************************************************

.HideIconBarPointer

 LDA controller1Start   \ If the Start button on controller 1 was being held
 AND #%11000000         \ down (bit 6 is set) but is no longer being held down
 CMP #%01000000         \ (bit 7 is clear) then keep going, otherwise jump to
 BNE hipo1              \ hipo1

 LDA #80                \ The Start button has been pressed and released, so
 STA iconBarChoice      \ set iconBarChoice to 80 to record this

 BNE hipo3              \ Jump to hipo3 to hide the icon bar pointer and return
                        \ from the subroutine

.hipo1

 LDA iconBarChoice      \ If iconBarChoice = 80 then we have already recorded
 CMP #80                \ that the Start button has been pressed but this has
 BEQ hipo3              \ not yet been processed (as otherwise it would have
                        \ been zeroed), so jump to hipo3 to hide the icon bar
                        \ pointer and return from the subroutine

.hipo2

 LDA #0                 \ Set iconBarChoice = 0 to clear the icon button choice
 STA iconBarChoice      \ so we don't process it again

.hipo3

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the icon bar pointer
                        \ sprites by moving them off-screen

 STA ySprite1           \ Set the y-coordinates for the four icon bar pointer
 STA ySprite2           \ sprites to 240, to move them off-screen
 STA ySprite3
 STA ySprite4

 RTS                    \ Return from the subroutine

