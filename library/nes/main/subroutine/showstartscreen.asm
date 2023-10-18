\ ******************************************************************************
\
\       Name: ShowStartScreen
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the start screen and start the game
\
\ ******************************************************************************

.ShowStartScreen

 LDA #&FF               \ Set soundVibrato = &FF &80 &1B &34 to set the seeds
 STA soundVibrato       \ for the randomised vibrato that's applied to sound
 LDA #&80               \ effects
 STA soundVibrato+1
 LDA #&1B
 STA soundVibrato+2
 LDA #&34
 STA soundVibrato+3

 JSR ResetMusic         \ Reset the current tune to 0 and stop the music

 JSR JAMESON_b6         \ Copy the default "JAMESON" commander to the buffer at
                        \ currentSlot (though this isn't actually used anywhere)

 JSR ResetOptions       \ Reset the game options to their default values

 LDA #1                 \ Set the font style to print in the normal font
 STA fontStyle

 LDX #&FF               \ Set the old view type in QQ11a to &FF (Segue screen
 STX QQ11a              \ from Title screen to Demo)

 TXS                    \ Set the stack pointer to &01FF, which is the standard
                        \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR RESET              \ Call RESET to initialise most of the game variables

 JSR ChooseLanguage_b6  \ Show the Start screen and process the language choice

                        \ Fall through into DEATH2 to show the title screen and
                        \ start the game

