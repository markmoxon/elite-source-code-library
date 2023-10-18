\ ******************************************************************************
\
\       Name: CheckSaveLoadBar
\       Type: Subroutine
\   Category: Save and load
\    Summary: Check the icon bar buttons on the Save and Load icon bar and
\             process any choices
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Determines the next step when we return from the
\                       routine:
\
\                         * Clear = exit from the SVE routine when we return and
\                                   go back to the icon bar processing routine
\                                   in TT102, so the button choice can be
\                                   processed there
\
\                         * Set = keep going as if nothing has happened (used to
\                                 resume from the pause menu or if nothing was
\                                 chosen, for example)
\
\   A                   A is preserved
\
\ ******************************************************************************

.CheckSaveLoadBar

 LDX iconBarChoice      \ If iconBarChoice = 0 then nothing has been chosen on
 BEQ cbar1              \ the icon bar (if it had, iconBarChoice would contain
                        \ the number of the chosen icon bar button), so jump to
                        \ cbar1 to return from the subroutine with the C flag
                        \ set, so we pick up where we left off

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 CPX #7                 \ If the Change Commander Name button was pressed,
 BEQ cbar2              \ jump to cbar2 to process it

 TXA                    \ Otherwise set X to the button number to pass to the
                        \ CheckForPause routine

 JSR CheckForPause_b0   \ If the Start button has been pressed then process the
                        \ pause menu and set the C flag, otherwise clear it
                        \
                        \ We now return this value of the C flag, so if we just
                        \ processed the pause menu then the C flag will be set,
                        \ so we pick up where we left off when we return,
                        \ otherwise it will be clear and we need to pass the
                        \ button choice back to TT102 to be processed there

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

.cbar1

 SEC                    \ Set the C flag so that when we return from the
                        \ routine, we pick up where we left off

 RTS                    \ Return from the subroutine

.cbar2

 LDA COK                \ If bit 7 of COK is set, then cheat mode has been
 BMI cbar4              \ applied, so jump to cbar4 to return from the
                        \ subroutine with the C flag clear, as cheats can't
                        \ change their commander name

 LDA #0                 \ Set iconBarChoice = 0 to clear the icon button choice
 STA iconBarChoice      \ so we don't process it again

 JSR ChangeCmdrName_b6  \ Process changing the commander name

 LDA iconBarChoice      \ If iconBarChoice = 0 then nothing has been chosen on
 BEQ cbar3              \ the icon bar during the renaming routine (if it had,
                        \ iconBarChoice would contain the number of the chosen
                        \ icon bar button), so jump to cbar3 to force a reload
                        \ of the save and load screen

 CMP #7                 \ If the Change Commander Name button was pressed
 BEQ cbar2              \ during the renaming routine, jump to cbar2 to restart
                        \ the renaming process

.cbar3

 LDA #6                 \ Set iconBarChoice to the Save and Load button, so
 STA iconBarChoice      \ when we return from the routine with the C flag clear,
                        \ the TT102 routine processes this as if we had chosen
                        \ this button, and reloads the save and load screen

.cbar4

 CLC                    \ Clear the C flag so that when we return from the
                        \ routine, the button number in iconBarChoice is passed
                        \ to TT102 to be processed as a button choice

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

