\ ******************************************************************************
\
\       Name: MoveInRightColumn
\       Type: Subroutine
\   Category: Save and load
\    Summary: Process moving the highlight when it's in the right column (the
\             save slots)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number in the right column containing the
\                       highlight (0 to 7)
\
\ ******************************************************************************

.MoveInRightColumn

 JSR HighlightSaveName  \ Highlight the name of the save slot in A, so the
                        \ highlight is shown in the correct slot in the right
                        \ column

 JSR UpdateSaveScreen   \ Update the screen

 JSR WaitForNoDirection \ Wait until the left and right buttons on controller 1
                        \ have been released and remain released for at least
                        \ four VBlanks

.mrig1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX controller1Up      \ If the up button on controller 1 is not being pressed,
 BPL mrig2              \ jump to mrig2 to move on to the next button

                        \ If we get here then the up button is being pressed

 CMP #0                 \ If A = 0 then we are already in the top slot in the
 BEQ mrig2              \ column, so jump to mrig2 to move on to the next button
                        \ as we can't move beyond the top of the column

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A
                        \ so that it reverts to the normal font, as we are about
                        \ to move the highlight elsewhere

 SEC                    \ Set A = A - 1
 SBC #1                 \
                        \ So A is now the slot number of the slot above

 JSR HighlightSaveName  \ Highlight the name of the save slot in A, so the
                        \ highlight moves to the new position

 JSR UpdateSaveScreen   \ Update the screen

.mrig2

 LDX controller1Down    \ If the down button on controller 1 is not being
 BPL mrig3              \ pressed, jump to mrig3 to move on to the next button

                        \ If we get here then the down button is being pressed

 CMP #7                 \ If A >= 7 then we are already in the bottom slot in
 BCS mrig3              \ the column, so jump to mrig3 to move on to the next
                        \ button as we can't move beyond the bottom of the
                        \ column

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A
                        \ so that it reverts to the normal font, as we are about
                        \ to move the highlight elsewhere

 CLC                    \ Set A = A + 1
 ADC #1                 \
                        \ So A is now the slot number of the slot below

 JSR HighlightSaveName  \ Highlight the name of the save slot in A, so the
                        \ highlight moves to the new position

 JSR UpdateSaveScreen   \ Update the screen

.mrig3

 LDX controller1Left03  \ If the left button on controller 1 was not being held
 BPL mrig4              \ down four VBlanks ago, jump to mrig4 to move on to the
                        \ next button

                        \ If we get here then the left button is being pressed

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A
                        \ so that it reverts to the normal font, as we are about
                        \ to move the highlight elsewhere

 JMP MoveInMiddleColumn \ Move the highlight left to the specified slot number
                        \ in the middle column and process any further button
                        \ presses accordingly

.mrig4

 LDX controller1Right03 \ If the right button on controller 1 was not being held
 BPL mrig5              \ down four VBlanks ago, jump to mrig5 to check the icon
                        \ bar buttons

                        \ If we get here then the right button is being pressed

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A
                        \ so that it reverts to the normal font, as we are about
                        \ to move the highlight elsewhere

 LDA #4                 \ This instruction has no effect as the first thing that
                        \ MoveToLeftColumn does is to set A to 9, which is the
                        \ slot number for the current commander

 JMP MoveToLeftColumn   \ Move the highlight to the left column (the current
                        \ commander) and process any further button presses
                        \ accordingly

.mrig5

                        \ If we get here then neither of the left or right
                        \ buttons have been pressed, so we move on to checking
                        \ the icon bar buttons

 JSR CheckSaveLoadBar   \ Check the icon bar buttons to see if any of them have
                        \ been chosen

 BCS mrig1              \ The C flag will be set if we are to resume what we
                        \ were doing (so we pick up where we left off after
                        \ processing the pause menu, for example, or keep going
                        \ if no button was chosen), so loop back to mrig1 to
                        \ keep checking for left and right button presses

                        \ If we get here then the C flag is clear and we need to
                        \ return from the SVE routine and go back to the icon
                        \ bar processing routine in TT102, so the button choice
                        \ can be processed there

 RTS                    \ Return from the subroutine

