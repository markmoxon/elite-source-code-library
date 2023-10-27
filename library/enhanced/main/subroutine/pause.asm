\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Missions
\    Summary: Display a rotating ship, waiting until a key is pressed, then
\             remove the ship from the screen
\
\ ******************************************************************************

.PAUSE

IF NOT(_NES_VERSION)

 JSR PAS1               \ Call PAS1 to display the rotating ship at space
                        \ coordinates (0, 112, 256) and scan the keyboard,
                        \ returning the internal key number in X (or 0 for no
                        \ key press)

 BNE PAUSE              \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to PAUSE, until
                        \ the key is released

.PAL1

 JSR PAS1               \ Call PAS1 to display the rotating ship at space
                        \ coordinates (0, 112, 256) and scan the keyboard,
                        \ returning the internal key number in X (or 0 for no
                        \ key press)

 BEQ PAL1               \ Keep looping up to PAL1 until a key is pressed

ELIF _NES_VERSION

 JSR DrawScreenInNMI_b0 \ Configure the NMI handler to draw the screen

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries from the
 STA firstPatternTile   \ first free pattern onwards, so we don't waste time
                        \ resending the static patterns we have already sent

 LDA #40                \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 40 * 8 = 320 (i.e. up to the end of tile
                        \ row 10)

 LDX #8                 \ Tell the NMI handler to send nametable entries from
 STX firstNametableTile \ tile 8 * 8 = 64 onwards (i.e. from the start of tile
                        \ row 2)

.paus1

 JSR PAS1_b0            \ Call PAS1 to display the rotating ship at space
                        \ coordinates (0, 100, 256) and scan the controllers

 LDA controller1A       \ Loop back to keep displaying the rotating ship until
 ORA controller1B       \ both the A button and B button have been released on
 BPL paus1              \ controller 1

.paus2

 JSR PAS1_b0            \ Call PAS1 to display the rotating ship at space
                        \ coordinates (0, 100, 256) and scan the controllers

 LDA controller1A       \ Loop back to keep displaying the rotating ship until
 ORA controller1B       \ either the A button or B button has been pressed on
 BMI paus2              \ controller 1

ENDIF

 LDA #0                 \ Set the ship's AI flag to 0 (no AI) so it doesn't get
 STA INWK+31            \ any ideas of its own

IF NOT(_NES_VERSION)

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

 JSR LL9                \ Draw the ship on screen to redisplay it

                        \ Fall through into MT23 to move to row 10, switch to
                        \ white text, and switch to lower case when printing
                        \ extended tokens

ELIF _NES_VERSION

 LDA #&93               \ Clear the screen and set the view type in QQ11 to &93
 JSR TT66_b0            \ (Mission 1 briefing: ship and text)


                        \ Fall through into MT23 to move to row 10, switch to
                        \ white text, and switch to lower case when printing
                        \ extended tokens

ENDIF

