\ ******************************************************************************
\
\       Name: MT9
\       Type: Subroutine
\   Category: Text
\    Summary: Tab to column 1 and set the current view type to 1
\
\ ******************************************************************************

.MT9

 LDA #1                 \ Call DOXC to move the text cursor to column 1
 JSR DOXC

 JMP TT66               \ Jump to TT66 to clear the screen and set the current
                        \ view type to 1, returning from the subroutine using a
                        \ tail call

