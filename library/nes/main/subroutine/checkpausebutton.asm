\ ******************************************************************************
\
\       Name: CheckPauseButton
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Check whether the pause button has been pressed or an icon bar
\             button has been chosen, and process pause/unpause if required
\
\ ******************************************************************************

.CheckPauseButton

 LDA iconBarChoice      \ If iconBarChoice = 0 then the icon bar pointer is over
 BEQ RTS4               \ a blank button, so jump to RTS4 to return from the
                        \ subroutine

                        \ Otherwise fall through into CheckForPause_b0 to pause
                        \ the game if the pause button is pressed

