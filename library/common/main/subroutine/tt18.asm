\ ******************************************************************************
\
\       Name: TT18
\       Type: Subroutine
\   Category: Flight
\    Summary: Try to initiate a jump into hyperspace
\
\ ------------------------------------------------------------------------------
\
\ Try to go through hyperspace. Called from TT102 in the main loop when the
\ hyperspace countdown has finished.
\
\ ******************************************************************************

.TT18

IF _CASSETTE_VERSION

 LDA QQ14               \ Subtract the distance to the selected system (in QQ8)
 SEC                    \ from the amount of fuel in our tank (in QQ14)
 SBC QQ8
 STA QQ14

ELIF _6502SP_VERSION

 LDA QQ14
 SEC
 SBC QQ8
 BCS P%+4
 LDA #0
 STA QQ14

ENDIF

 LDA QQ11               \ If the current view is not a space view, jump to ee5
 BNE ee5                \ to skip the following

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR LL164              \ Call LL164 to show the hyperspace tunnel and make the
                        \ hyperspace sound

.ee5

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

 AND PATG               \ If the game is configured to show the author's names
                        \ on the start-up screen, then PATG will contain &FF,
                        \ otherwise it will be 0

 BMI ptg                \ By now, A will be negative if we are holding down CTRL
                        \ and author names are configured, which is what we have
                        \ to do in order to trigger a manual mis-jump, so jump
                        \ to ptg to do a mis-jump (ptg not only mis-jumps, but
                        \ updates the competition flags, so Acornsoft could tell
                        \ from the competition code whether this feature had
                        \ been used)

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (1% chance) then jump to MJP to trigger a
 BCS MJP                \ mis-jump into witchspace

\JSR TT111              \ This instruction is commented out in the original
                        \ source. It finds the closest system to coordinates
                        \ (QQ9, QQ10), but we don't need to do this as the
                        \ crosshairs will already be on a system by this point

 JSR hyp1+3             \ Jump straight to the system at (QQ9, QQ10) without
                        \ first calculating which system is closest

IF _CASSETTE_VERSION

 JSR GVL                \ Calculate the availability for each market item in the
                        \ new system

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR SOLAR              \ Halve our legal status, update the missile indicators,
                        \ and set up data blocks and slots for the planet and
                        \ sun

IF _CASSETTE_VERSION

 LDA QQ11               \ If the current view in QQ11 is not a space view (0) or
 AND #%00111111         \ one of the charts (64 or 128), return from the
 BNE hyR                \ subroutine (as hyR contains an RTS)

ELIF _6502SP_VERSION

 LDA QQ11               \ If the current view in QQ11 is not a space view (0) or
 AND #%00111111         \ one of the charts (64 or 128), return from the
 BNE RTS111             \ subroutine (as RTS111 contains an RTS)

ENDIF

 JSR TTX66              \ Otherwise clear the screen and draw a white border

 LDA QQ11               \ If the current view is one of the charts, jump to
 BNE TT114              \ TT114 (from which we jump to the correct routine to
                        \ display the chart)

 INC QQ11               \ This is a space view, so increment QQ11 to 1

                        \ Fall through into TT110 to show the front space view
