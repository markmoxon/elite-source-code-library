\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Keyboard
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

 JSR CF186_BANK6         \ ???
 JSR LD8C5
 LDA tileNumber
 STA L00D2
 LDA #&28
 STA L00D8
 LDX #8
 STX L00CC

.loop_CB392

 JSR PAS1
 LDA L04B2
 ORA L04B4
 BPL loop_CB392

.loop_CB39D

 JSR PAS1
 LDA L04B2
 ORA L04B4
 BMI loop_CB39D

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

 LDA #&93               \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to ???

                        \ Fall through into MT23 to move to row 10, switch to
                        \ white text, and switch to lower case when printing
                        \ extended tokens

ENDIF

