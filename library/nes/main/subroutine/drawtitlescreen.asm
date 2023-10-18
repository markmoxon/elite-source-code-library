\ ******************************************************************************
\
\       Name: DrawTitleScreen
\       Type: Subroutine
\   Category: Start and end
\    Summary: Draw a sequence of rotating ships on-screen while checking for
\             button presses on the controllers
\
\ ******************************************************************************

.DrawTitleScreen

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

 LDA #0                 \ Set the music to tune 0 (no music)
 JSR ChooseMusic_b6

 JSR HideMostSprites    \ Hide all sprites except for sprite 0 and the icon bar
                        \ pointer

 LDA #&FF               \ Set the old view type in QQ11a to &FF (Segue screen
 STA QQ11a              \ from Title screen to Demo)

 LDA #1                 \ Set numberOfPilots = 1 to configure the game to use
 STA numberOfPilots     \ two pilots by default (though this will probably get
                        \ changed in the TITLE routine, or below)

 LDA #50                \ Set the NMI timer, which decrements each VBlank, to 50
 STA nmiTimer           \ so it counts down to zero and back up to 50 again

 LDA #0                 \ Set (nmiTimerHi nmiTimerLo) = 0 so we can time how
 STA nmiTimerLo         \ long to show the rotating ships before switching back
 STA nmiTimerHi         \ to the Start screen

.dtit1

 LDY #0                 \ We are about to start running through a list of ships
                        \ to display on the title screen, so set a ship counter
                        \ in Y

.dtit2

 STY titleShip          \ Store the ship counter in titleShip so we can retrieve
                        \ it below

 LDA titleShipType,Y    \ Set A to the ship type of the ship we want to display,
                        \ from the Y-th entry in the titleShipType table

 BEQ dtit1              \ If the ship type is zero then we have already worked
                        \ our way through the list, so jump back to dtit1 to
                        \ start from the beginning of the list again

 TAX                    \ Store the ship type in X

 LDA titleShipDist,Y    \ Set Y to the distance of the ship we want to display,
 TAY                    \ from the Y-th entry in the titleShipDist table

 LDA #6                 \ Call TITLE to draw the ship type in X, starting with
 JSR TITLE              \ it far away, and bringing it to a distance of Y (the
                        \ argument in A is ignored)

 BCS dtit3              \ If a button was pressed while the ship was being shown
                        \ on-screen, TITLE will return with the C flag set, in
                        \ which case jump to dtit3 to stop the music and return
                        \ from the subroutine

 LDY titleShip          \ Restore the ship counter that we stored above

 INY                    \ Increment the ship counter in Y to point to the next
                        \ ship in the list

 LDA nmiTimerHi         \ If the high byte of (nmiTimerHi nmiTimerLo) is still 0
 CMP #1                 \ then jump back to dtit2 to show the next ship
 BCC dtit2

                        \ If we get here then the NMI timer has run down to the
                        \ point where (nmiTimerHi nmiTimerLo) is >= 256, which
                        \ means we have shown the title screen for at least
                        \ 50 * 256 VBlanks, as each tick of nmiTimerLo happens
                        \ when the nmiTimer has counted down from 50 VBlanks,
                        \ and each tick happens once every VBlank
                        \
                        \ On the PAL NES, VBlank happens 50 times a second, so
                        \ this means the title screen has been showing for 256
                        \ seconds, or about 4 minutes and 16 seconds
                        \
                        \ On the NTSC NES, VBlank happens 60 times a second, so
                        \ this means the title screen has been showing for 213
                        \ seconds, or about 3 minutes and 33 seconds

 LSR numberOfPilots     \ Set numberOfPilots = 0 to configure the game for one
                        \ pilot

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the music

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

 LDA languageIndex      \ Set K% to the index of the currently selected
 STA K%                 \ language, so when we show the Start screen, the
                        \ correct language is highlighted

 LDA #5                 \ Set K%+1 = 5 to use as the value of the third counter
 STA K%+1               \ when deciding how long to wait on the Start screen
                        \ before auto-playing the demo

 JMP ResetToStartScreen \ Reset the stack and the game's variables and show the
                        \ Start screen, returning from the subroutine using a
                        \ tail call

.dtit3

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the music

 RTS                    \ Return from the subroutine

