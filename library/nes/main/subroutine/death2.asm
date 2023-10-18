\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ------------------------------------------------------------------------------
\
\ This routine is called following death, and when the game is quit via the
\ pause menu.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.DEATH2

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 INX                    \ Set chartToShow = 0 so the chart button on the icon
 STX chartToShow        \ bar shows the Short-range Chart when chosen

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDA #5                 \ Set the icon par pointer to button 5 (which is the
 JSR SetIconBarPointer  \ sixth button of 12, just before the halfway point)

 JSR U%                 \ Call U% to clear the key logger

 JSR DrawTitleScreen    \ Draw the title screen with the rotating ships,
                        \ returning when a key is pressed

 LDA controller1Select  \ If Select, Start, A and B are all pressed at the same
 AND controller1Start   \ time on controller 1, jump to dead2 to skip the demo
 AND controller1A       \ and show the credits scroll text instead
 AND controller1B
 BNE dead2

 LDA controller1Select  \ If Select is pressed on either controller, jump to
 ORA controller2Select  \ dead3 to skip the demo and start the game straight
 BNE dead3              \ away

                        \ If we get here then we start the combat demo

 LDA #0                 \ Store 0 on the stack, so this can be retrieved below
 PHA                    \ to pass to ShowScrollText, so the demo gets run after
                        \ the scroll text is shown

 JSR BR1                \ Reset a number of variables, ready to start a new game

 LDA #&FF               \ Set the view type in QQ11 to &FF (Segue screen from
 STA QQ11               \ Title screen to Demo)

 LDA autoPlayDemo       \ If autoPlayDemo is zero then the demo is not being
 BEQ dead1              \ auto-played, so jump to dead1 to skip the following
                        \ instruction

 JSR SetupDemoUniverse  \ The demo is running and is being auto-played by the
                        \ computer, so call SetupDemoUniverse to set up the
                        \ local bubble for the demo

.dead1

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA #4                 \ Select and play the combat demo music (tune 4,
 JSR ChooseMusic_b6     \ "Assassin's Touch" followed by "Game Theme")

 LDA tuneSpeed          \ Set tuneSpeed = tuneSpeed + 6
 CLC                    \
 ADC #6                 \ This speeds up the music in the combat demo to make
 STA tuneSpeed          \ things a bit more exciting

 PLA                    \ Set A to the value of A that we put on the stack above
                        \ (i.e. set A = 0)

 JMP ShowScrollText_b6  \ Jump to ShowScrollText to show the scroll text and run
                        \ the demo, returning from the subroutine using a tail
                        \ call

.dead2

                        \ If we get here then we show the credits scroll text

 JSR BR1                \ Reset a number of variables, ready to start a new game

 LDA #&FF               \ Set the view type in QQ11 to &FF (Segue screen from
 STA QQ11               \ Title screen to Demo)

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA #4                 \ Select and play the combat demo music (tune 4,
 JSR ChooseMusic_b6     \ "Assassin's Touch" followed by "Game Theme")

 LDA #2                 \ Set A = 2 to pass to ShowScrollText, so the credits
                        \ scroll text is shown instead of the demo introduction,
                        \ and to skip the demo after the scroll text

 JMP ShowScrollText_b6  \ Jump to ShowScrollText to show the scroll text and
                        \ skip the demo, returning from the subroutine using a
                        \ tail call

.dead3

                        \ If we get here then we start the game without playing
                        \ the demo

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

                        \ Fall through into StartGame to reset the stack and go
                        \ to the docking bay (i.e. show the Status Mode screen)

