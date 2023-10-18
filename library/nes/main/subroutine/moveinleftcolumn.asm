\ ******************************************************************************
\
\       Name: MoveInLeftColumn
\       Type: Subroutine
\   Category: Save and load
\    Summary: Process moving the highlight when it's in the left column (the
\             current commander)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Must be set to 9, as that represents the slot number of
\                       the left column containing the current commander
\
\ ******************************************************************************

.MoveInLeftColumn

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX controller1Left03  \ If the left button on controller 1 was not being held
 BPL mlef3              \ down four VBlanks ago or for the three VBlanks before
                        \ that, jump to mlef3 to check the right button

                        \ If we get here then the left button is being pressed,
                        \ so we need to move the highlight left from its current
                        \ position (which is given in A and is always 9) to the
                        \ right column

 JSR PrintSaveName      \ Print the name of the commander file in its current
                        \ position in A, to remove the highlight

 CMP #9                 \ If A = 9 then we have pressed the left button while
 BEQ mlef1              \ highlighting the current commander name on the left
                        \ of the screen, so we need to move the highlight to the
                        \ right column, so jump to mlef1 to do this
                        \
                        \ This will always be the case as this routine is only
                        \ called with A = 9 (as that's the slot number we use
                        \ to represent the current commander in the left
                        \ column), so presumably this logic is left over from a
                        \ time when this routine was a bit more generic

 LDA #0                 \ Otherwise the highlight must currently be in either
                        \ the middle or right column, so set A = 0 so the
                        \ highlight moves to the top of the new column (though
                        \ again, this will never happen)

 JMP mlef2              \ Jump to mlef2 to move the highlight to the right
                        \ column

.mlef1

                        \ If we get here then we have pressed the left button
                        \ while highlighting the current commander name on the
                        \ left of the screen

 LDA #4                 \ Set A = 4 so the call to MoveInRightColumn moves the
                        \ highlight to slot 4 in the right column, which is at
                        \ the same vertical position as the current commander
                        \ name on the left

.mlef2

 JMP MoveInRightColumn  \ Move the highlight left to the specified slot number
                        \ in the right column and process any further button
                        \ presses accordingly

.mlef3

 LDX controller1Right03 \ If the right button on controller 1 was not being held
 BPL mlef6              \ down four VBlanks ago or for the three VBlanks before
                        \ that, jump to mlef6 to check the icon bar buttons

                        \ If we get here then the right button is being pressed,
                        \ so we need to move the highlight right from its
                        \ current position (which is given in A and is always 9)
                        \ to the middle column

 JSR PrintSaveName      \ Print the name of the commander file in its current
                        \ position in A, to remove the highlight

 CMP #9                 \ If A = 9 then we have pressed the right button while
 BEQ mlef4              \ highlighting the current commander name on the left of
                        \ the screen, so we need to move the highlight to the
                        \ middle column, so jump to mlef4 to do this
                        \
                        \ This will always be the case as this routine is only
                        \ called with A = 9 (as that's the slot number we use
                        \ to represent the current commander in the left
                        \ column), so presumably this logic is left over from a
                        \ time when this routine was a bit more generic

 LDA #0                 \ Otherwise the highlight must currently be in either
                        \ the middle or right column, so set A = 0 so the
                        \ highlight moves to the top of the new column (though
                        \ again, this will never happen)

 JMP mlef5              \ Jump to mlef5 to move the highlight to the middle
                        \ column

.mlef4

                        \ If we get here then we have pressed the right button
                        \ while highlighting the current commander name on the
                        \ left of the screen

 LDA #4                 \ Set A = 4 so the call to MoveInMiddleColumn moves the
                        \ highlight to slot 4 in the middle column, which is at
                        \ the same vertical position as the current commander
                        \ name on the left

.mlef5

 JMP MoveInMiddleColumn \ Move the highlight left to the specified slot number
                        \ in the middle column and process any further button
                        \ presses accordingly

.mlef6

                        \ If we get here then neither of the left or right
                        \ buttons have been pressed, so we move on to checking
                        \ the icon bar buttons

 JSR CheckSaveLoadBar   \ Check the icon bar buttons to see if any of them have
                        \ been chosen

 BCS MoveInLeftColumn   \ The C flag will be set if we are to resume what we
                        \ were doing (so we pick up where we left off after
                        \ processing the pause menu, for example), so loop back
                        \ to the start of the routine to keep checking for left
                        \ and right button presses

                        \ If we get here then the C flag is clear and we need to
                        \ return from the SVE routine and go back to the icon
                        \ bar processing routine in TT102

 RTS                    \ Return from the subroutine

