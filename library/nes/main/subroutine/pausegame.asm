\ ******************************************************************************
\
\       Name: PauseGame
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Pause the game and process choices from the pause menu until the
\             game is unpaused by another press of Start
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\   nmiTimer            nmiTimer is preserved
\
\   nmiTimerHi          nmiTimerHi is preserved
\
\   nmiTimerLo          nmiTimerLo is preserved
\
\   showIconBarPointer  showIconBarPointer is preserved
\
\   iconBarType         iconBarType is preserved
\
\ ******************************************************************************

.PauseGame

 TYA                    \ Store X and Y on the stack so we can retrieve them
 PHA                    \ below
 TXA
 PHA

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA nmiTimer           \ Store nmiTimer and (nmiTimerHi nmiTimerLo) on the
 PHA                    \ stack so we can retrieve them below
 LDA nmiTimerLo
 PHA
 LDA nmiTimerHi
 PHA

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA showIconBarPointer \ Store showIconBarPointer on the stack so we can
 PHA                    \ retrieve it below

 LDA iconBarType        \ Store iconBarType on the stack so we can retrieve it
 PHA                    \ below

 LDA #&FF               \ Set showIconBarPointer = &FF to indicate that we
 STA showIconBarPointer \ should show the icon bar pointer

 LDA #3                 \ Show icon bar type 3 (Pause) on-screen
 JSR ShowIconBar_b3

.paug1

 LDY #4                 \ Wait until four NMI interrupts have passed (i.e. the
 JSR DELAY              \ next four VBlanks)

 JSR SetKeyLogger_b6    \ Populate the key logger table with the controller
                        \ button presses and return the button number in X
                        \ if an icon bar button has been chosen

 TXA                    \ Set A to the button number if an icon bar button has
                        \ been chosen

 CMP #80                \ If the Start button was pressed to pause the game then
 BNE paug2              \ A will be 80, so jump to paug2 to process choices from
                        \ the pause menu

                        \ Otherwise the Start button was pressed for a second
                        \ time (which returns X = 0 from SetKeyLogger), so now
                        \ we remove the pause menu

 PLA                    \ Retrieve iconBarType from the stack into A

 JSR ShowIconBar_b3     \ Show icon bar type A on-screen, so we redisplay the
                        \ icon bar that was on the screen before the game was
                        \ paused

 PLA                    \ Set showIconBarPointer to the value we stored on the
 STA showIconBarPointer \ stack above, so it is preserved

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 PLA                    \ Set nmiTimer and (nmiTimerHi nmiTimerLo) to the values
 STA nmiTimerHi         \ we stored on the stack above, so they are preserved
 PLA
 STA nmiTimerLo
 PLA
 STA nmiTimer

 PLA                    \ Set X and Y to the values we stored on the stack
 TAX                    \ above, so they are preserved
 PLA
 TAY

 RTS                    \ Return from the subroutine

.paug2

                        \ If we get here then an icon bar button has been chosen
                        \ and the button number is in A

 CMP #52                \ If the Sound toggle button was not chosen, jump to
 BNE paug3              \ paug3 to keep checking

 LDA DNOIZ              \ The Sound toggle button was chosen, so flip the value
 EOR #&FF               \ of DNOIZ to toggle between sound on and sound off
 STA DNOIZ

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug3

 CMP #51                \ If the Music toggle button was not chosen, jump to
 BNE paug6              \ paug6 to keep checking

 LDA disableMusic       \ The Music toggle button was chosen, so flip the value
 EOR #&FF               \ of disableMusic to toggle between music on and music
 STA disableMusic       \ off

 BPL paug4              \ If the toggle was flipped to 0, then music is enabled
                        \ so jump to paug4 to start the music playing (if a tune
                        \ is configured)

 JSR StopSounds_b6      \ Otherwise music has just been enabled, so call
                        \ StopSounds to stop any sounds that are being made
                        \ (music or sound effects)

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug4

                        \ If we get here then music was just enabled

 LDA newTune            \ If newTune = 0 then no tune is configured to play, so
 BEQ paug5              \ jump to paug5 to skip the following

 AND #%01111111         \ Clear bit 7 of newTune to extract the tune number that
                        \ is configured to play

 JSR ChooseMusic_b6     \ Call ChooseMusic to start playing the tune in A

.paug5

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug6

 CMP #60                \ If the Restart button was not chosen, jump to paug7
 BNE paug7

                        \ The Restart button was just chosen, so we now restart
                        \ the game

 PLA                    \ Retrieve iconBarType from the stack into A (and ignore
                        \ it)

 PLA                    \ Set showIconBarPointer to the value we stored on the
 STA showIconBarPointer \ stack above, so it is preserved

 JMP DEATH2_b0          \ Jump to DEATH2 to restart the game (which also resets
                        \ the stack pointer, so we can ignore all the other
                        \ values that we put on the stack above)

.paug7

 CMP #53                \ If the Number of Pilots button was not chosen, jump
 BNE paug8              \ to paug8 to keep checking

 LDA numberOfPilots     \ The Number of Pilots button was chosen, so flip the
 EOR #1                 \ value of numberOfPilots between 0 and 1 to change the
 STA numberOfPilots     \ number of pilots between 1 and 2

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug8

 CMP #49                \ If the "Direction of y-axis" toggle button was not
 BNE paug9              \ chosen, jump to paug9 to keep checking

 LDA JSTGY              \ The "Direction of y-axis" toggle button was chosen, so
 EOR #&FF               \ flip the value of JSTGY to toggle the direction of the
 STA JSTGY              \ controller y-axis

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug9

 CMP #50                \ If the Damping toggle button was not chosen, jump to
 BNE paug10             \ paug10 to keep checking

 LDA DAMP               \ The Damping toggle button was chosen, so flip the
 EOR #&FF               \ value of DAMP to toggle between damping on and damping
 STA DAMP               \ off

 JMP paug11             \ Jump to paug11 to update the icon bar and loop back to
                        \ keep listening for button presses

.paug10

 JMP paug1              \ Jump back to paug1 to keep listening for button
                        \ presses

.paug11

 JSR UpdateIconBar_b3   \ Update the icon bar to show updated icons for any
                        \ changed options

 JMP paug1              \ Jump back to paug1 to keep listening for button
                        \ presses

