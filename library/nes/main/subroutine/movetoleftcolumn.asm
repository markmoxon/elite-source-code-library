\ ******************************************************************************
\
\       Name: MoveToLeftColumn
\       Type: Subroutine
\   Category: Save and load
\    Summary: Move the highlight to the left column (the current commander)
\
\ ******************************************************************************

.MoveToLeftColumn

 LDA #9                 \ Set A = 9 to set the position of the highlight to slot
                        \ 9, which we use to represent the current commander in
                        \ the left column

 JSR HighlightSaveName  \ Print the name of the commander file saved in slot 9
                        \ as a highlighted name, so this prints the current
                        \ commander name on the left of the screen, under the
                        \ "CURRENT POSITION" header, in the highlight font

 JSR UpdateSaveScreen   \ Update the screen

 JSR WaitForNoDirection \ Wait until the left and right buttons on controller 1
                        \ have been released and remain released for at least
                        \ four VBlanks

 JMP MoveInLeftColumn   \ Move the highlight to the current commander in the
                        \ left column and process any further button presses
                        \ accordingly

