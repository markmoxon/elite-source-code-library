\ ******************************************************************************
\
\       Name: qv
\       Type: Subroutine
\   Category: Equipment
\    Summary: Print a popup menu of the four space views, for buying lasers
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Returns:
\
\   X                   The chosen view number (0-3)
\
\ ******************************************************************************

.qv

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1Left03  \ If A button is being pressed, or the left or right
 ORA controller1Right03 \ buttons were being pressed four VBlanks ago, then
 ORA controller1A       \ loop back to qv until they are released
 BMI qv

 LDY #3                 \ We now print a popup menu showing all four views, so
                        \ set a view counter in Y, starting with view 3 (right)

.vpop1

 JSR PrintLaserView     \ Print the name of the laser view specified in Y at the
                        \ correct on-screen position for the popup menu

 DEY                    \ Decrement the view counter in Y

 BNE vpop1              \ Loop back to print the next view until we have printed
                        \ all four view names in the popup

                        \ Next, we highlight the first view (front) as by this
                        \ point Y = 0

 LDA #2                 \ Set the font style to print in the highlight font
 STA fontStyle

 JSR PrintLaserView     \ Print the name of the laser view specified in Y at the
                        \ correct on-screen position for the popup menu

 LDA #1                 \ Set the font style to print in the normal font
 STA fontStyle

                        \ We now draw a box around the list of views to make it
                        \ look like a popup menu

 LDA #11                \ Move the text cursor to column 11
 STA XC

 STA K+2                \ Set K+2 = 11 to pass to DrawSmallBox as the text row
                        \ on which to draw the top-left corner of the small box

 LDA #7                 \ Move the text cursor to row 7
 STA YC

 STA K+3                \ Set K+3 = 7 to pass to DrawSmallBox as the text column
                        \ on which to draw the top-left corner of the small box

 LDX languageIndex      \ Set K to the correct width for the laser view popup in
 LDA popupWidth,X       \ the chosen language, to pass to DrawSmallBox as the
 STA K                  \ width of the small box

 LDA #6                 \ Set K+1 = 6 to pass to DrawSmallBox as the height of
 STA K+1                \ the small box

 JSR DrawSmallBox_b3    \ Draw a box around the popup, with the top-left corner
                        \ at (7, 11), a height of 6 rows, and the correct width
                        \ for the chosen language

 JSR DrawScreenInNMI    \ Configure the NMI handler to draw the screen, so the
                        \ screen gets updated

                        \ The popup menu is now on-screen, so now we manage the
                        \ process of making a choice

 LDY #0                 \ We use Y to keep track of the highlighted view, which
                        \ we set to the front view above, so set Y = 0 to
                        \ reflect this

.vpop2

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1Up      \ If the up button is not being pressed, jump to vpop4
 BPL vpop4              \ to move on to the next button check

                        \ If we get here then we need to move the highlight up
                        \ the menu, wrapping around if we go off the top

 JSR PrintLaserView     \ Print the name of the laser view specified in Y at the
                        \ correct on-screen position for the popup menu, to
                        \ remove the highlight from the current selection

 DEY                    \ Decrement Y to move the number of the selected view up
                        \ the menu

 BPL vpop3              \ If the view number is positive when we have not gone
                        \ off the top of the menu, so jump to vpop3 to skip the
                        \ following instruction

 LDY #3                 \ We just moved past the top of the menu, so set Y to 3
                        \ to move the selection to the bottom entry in the menu
                        \ (the right view)

.vpop3

 JSR HighlightLaserView \ Highlight the Y-th entry in the popup menu, to reflect
                        \ the new choice

.vpop4

 LDA controller1Down    \ If the down button is not being pressed, jump to vpop6
 BPL vpop6              \ to move on to the next button check

                        \ If we get here then we need to move the highlight down
                        \ the menu, wrapping around if we go off the bottom

 JSR PrintLaserView     \ Print the name of the laser view specified in Y at the
                        \ correct on-screen position for the popup menu, to
                        \ remove the highlight from the current selection

 INY                    \ Increment Y to move the number of the selected view
                        \ down the menu

 CPY #4                 \ If Y is not 4 then we have not gone off the bottom of
 BNE vpop5              \ the menu, so jump to vpop5 to skip the following
                        \ instruction

 LDY #0                 \ We just moved past the bottom of the menu, so set Y to
                        \ 0 to move the selection to the top entry in the menu
                        \ (the front view)

.vpop5

 JSR HighlightLaserView \ Highlight the Y-th entry in the popup menu, to reflect
                        \ the new choice

.vpop6

 LDA controller1A       \ If the A button is being pressed, jump to vpop7 to
 BMI vpop7              \ return the highlighted view as the chosen laser view

 LDA iconBarChoice      \ If iconBarChoice = 0 then nothing has been chosen on
 BEQ vpop2              \ the icon bar (if it had, iconBarChoice would contain
                        \ the number of the chosen icon bar button), so loop
                        \ back to vpop2 to keep processing the popup keys

                        \ If we get here then either a choice has been made on
                        \ the icon bar during NMI and the number of the icon bar
                        \ button is in iconBarChoice, or the Start button has
                        \ been pressed and iconBarChoice is 80

 CMP #80                \ If iconBarChoice = 80 then the Start button has been
 BNE vpop7              \ pressed to pause the game, so if this is not the case,
                        \ then a different icon bar option has been chosen, so
                        \ jump to vpop7 to return from the subroutine and abort
                        \ the laser purchase

                        \ If we get here then iconBarChoice = 80, which means
                        \ the Start button has been pressed to pause the game

 LDA #0                 \ Set iconBarChoice = 0 to clear the pause button press
 STA iconBarChoice      \ so we don't simply re-enter the pause menu when we
                        \ resume

 JSR PauseGame_b6       \ Pause the game and process choices from the pause menu
                        \ until the game is unpaused by another press of Start

 JMP vpop2              \ Jump back to vpop2 to pick up where we left off and go
                        \ back to processing the popup choice

.vpop7

 TYA                    \ Copy the number of the highlighted laser view from Y
 TAX                    \ into X, so we can return the choice in X

 RTS                    \ Return from the subroutine

