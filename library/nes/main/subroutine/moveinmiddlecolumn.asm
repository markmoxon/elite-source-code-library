\ ******************************************************************************
\
\       Name: MoveInMiddleColumn
\       Type: Subroutine
\   Category: Save and load
\    Summary: Process moving the highlight when it's in the middle column
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number in the middle column containing the
\                       highlight (0 to 7)
\
\ ******************************************************************************

.MoveInMiddleColumn

 JSR PrintNameInMiddle  \ Print the name of the commander file in A, so the
                        \ highlight is shown in the correct slot in the middle
                        \ column

 JSR UpdateSaveScreen   \ Update the screen

 JSR WaitForNoDirection \ Wait until the left and right buttons on controller 1
                        \ have been released and remain released for at least
                        \ four VBlanks

.mmid1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX controller1Up      \ If the up button on controller 1 is not being pressed,
 BPL mmid2              \ jump to mmid2 to move on to the next button

                        \ If we get here then the up button is being pressed

 CMP #0                 \ If A = 0 then we are already in the top slot in the
 BEQ mmid2              \ column, so jump to mmid2 to move on to the next button
                        \ as we can't move beyond the top of the column

 JSR ClearNameInMiddle  \ Clear the name of the commander file from slot A in
                        \ the middle column, as we are about to move the
                        \ highlight elsewhere

 SEC                    \ Set A = A - 1
 SBC #1                 \
                        \ So A is now the slot number of the slot above

 JSR PrintNameInMiddle  \ Print the name of the commander file in slot A in the
                        \ middle column, so the highlight moves to the new
                        \ position

 JSR UpdateSaveScreen   \ Update the screen

.mmid2

 LDX controller1Down    \ If the down button on controller 1 is not being
 BPL mmid3              \ pressed, jump to mmid3 to move on to the next button

                        \ If we get here then the down button is being pressed

 CMP #7                 \ If A >= 7 then we are already in the bottom slot in
 BCS mmid3              \ the column, so jump to mmid3 to move on to the next
                        \ button as we can't move beyond the bottom of the
                        \ column

 JSR ClearNameInMiddle  \ Clear the name of the commander file from slot A in
                        \ the middle column, as we are about to move the
                        \ highlight elsewhere

 CLC                    \ Set A = A + 1
 ADC #1                 \
                        \ So A is now the slot number of the slot below

 JSR PrintNameInMiddle  \ Print the name of the commander file in slot A in the
                        \ middle column, so the highlight moves to the new
                        \ position

 JSR UpdateSaveScreen   \ Update the screen

.mmid3

 LDX controller1Left03  \ If the left button on controller 1 was not being held
 BPL mmid4              \ down four VBlanks ago, jump to mmid4 to move on to the
                        \ next button

                        \ If we get here then the left button is being pressed

 CMP #4                 \ We can only move left from the middle column if we are
 BNE mmid4              \ at the same height as the current commander slot in
                        \ the column to the left
                        \
                        \ The current commander slot is to the left of slot 4
                        \ in the middle column, so jump to mmid4 to move on to
                        \ the next button if we are not currently in slot 4 in
                        \ the middle column

                        \ If we get here then we are in slot 4 in the middle
                        \ column, so we can now move left

 JSR ClearNameInMiddle  \ Clear the name of the commander file from slot A in
                        \ the middle column, as we are about to move the
                        \ highlight elsewhere

 LDA #9                 \ Set A = 9 to set the position of the highlight to slot
                        \ 9, which we use to represent the current commander in
                        \ the left column

 JSR SaveLoadCommander  \ Load the chosen commander file into NAME to overwrite
                        \ the game's current commander, so this effectively
                        \ loads the chosen commander into the game

 JSR UpdateIconBar_b3   \ Update the icon bar in case we just changed the
                        \ current commander to a cheat file, in which case we
                        \ hide the button that lets you change the commander
                        \ name

 JMP MoveToLeftColumn   \ Move the highlight to the left column (the current
                        \ commander) and process any further button presses
                        \ accordingly

.mmid4

 LDX controller1Right03 \ If the right button on controller 1 was not being held
 BPL mmid5              \ down four VBlanks ago, jump to mmid5 to check the icon
                        \ bar buttons

                        \ If we get here then the right button is being pressed

 JSR ClearNameInMiddle  \ Clear the name of the commander file from slot A in
                        \ the middle column, as we are about to move the
                        \ highlight elsewhere

 JSR SaveLoadCommander  \ Save the commander into the chosen save slot by
                        \ splitting it up and saving it into three parts in
                        \ saveSlotPart1, saveSlotPart2 and saveSlotPart3

 JMP MoveInRightColumn  \ Move the highlight to the right column (the save
                        \ slots) and process any further button presses
                        \ accordingly

.mmid5

                        \ If we get here then neither of the left or right
                        \ buttons have been pressed, so we move on to checking
                        \ the icon bar buttons

 JSR CheckSaveLoadBar   \ Check the icon bar buttons to see if any of them have
                        \ been chosen

 BCS mmid1              \ The C flag will be set if we are to resume what we
                        \ were doing (so we pick up where we left off after
                        \ processing the pause menu, for example, or keep going
                        \ if no button was chosen), so loop back to mmid1 to
                        \ keep checking for left and right button presses

                        \ If we get here then the C flag is clear and we need to
                        \ return from the SVE routine and go back to the icon
                        \ bar processing routine in TT102, so the button choice
                        \ can be processed there

 RTS                    \ Return from the subroutine

