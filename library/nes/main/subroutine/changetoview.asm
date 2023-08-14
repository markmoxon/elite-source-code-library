\ ******************************************************************************
\
\       Name: ChangeToView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen, set the current view type and move the cursor to
\             row 0
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the new current view (see QQ11 for a list of
\                       view types)
\
\ ******************************************************************************

.ChangeToView

 JSR TT66               \ Clear the screen and set the current view type

 LDA #0                 \ Move the text cursor to row 0
 STA YC

 RTS                    \ Return from the subroutine

