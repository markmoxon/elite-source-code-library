\ ******************************************************************************
\
\       Name: CheckForPause
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Pause the game if the pause button (Start) is pressed
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The button number to check to see if it is the pause
\                       button (a value of 80 indicates the pause button)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The status of the pause button:
\
\                         * Clear if the pause button is not being pressed
\
\                         * Set if the pause button is being pressed, in which
\                           case we return from the subroutine after pausing the
\                           the game, processing any choices from the icon bar,
\                           and unpausing the game when Start is pressed again
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   CheckForPause-3     Set A to the number of the icon bar button in
\                       iconBarChoice so we check whether the pause button is
\                       being pressed
\
\ ******************************************************************************

 LDA iconBarChoice      \ Set A to the number of the icon bar button that has
                        \ been chosen from the icon bar (for when this routine
                        \ is called via the CheckForPause-3 entry point)

.CheckForPause

 CMP #80                \ If iconBarChoice = 80 then the Start button has been
 BNE cpse1              \ pressed to pause the game, so if this is not the case,
                        \ jump to cpse1 to return from the subroutine with the
                        \ C flag clear and without pausing

 LDA #0                 \ Set iconBarChoice = 0 to clear the pause button press
 STA iconBarChoice      \ so we don't simply re-enter the pause menu when we
                        \ resume

 JSR PauseGame_b6       \ Pause the game and process choices from the pause menu
                        \ until the game is unpaused by another press of Start

 SEC                    \ Set the C flag to indicate that the game was paused

 RTS                    \ Return from the subroutine

.cpse1

 CLC                    \ Clear the C flag to indicate that the game was not
                        \ paused

 RTS                    \ Return from the subroutine

