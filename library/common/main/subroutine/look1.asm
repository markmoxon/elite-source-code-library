\ ******************************************************************************
\
\       Name: LOOK1
\       Type: Subroutine
\   Category: Flight
\    Summary: Initialise the space view
\
\ ------------------------------------------------------------------------------
\
\ Initialise the space view, with the direction of view given in X. This clears
\ the upper screen and draws the laser crosshairs, if the view in X has lasers
\ fitted. It also wipes all the ships from the scanner, so we can recalculate
\ ship positions for the new view (they get put back in the main flight loop).
\
\ Arguments:
\
\   X                   The space view to set:
\
\                         * 0 = front
\
\                         * 1 = rear
\
\                         * 2 = left
\
\                         * 3 = right
\
\ ******************************************************************************

.LO2

 RTS                    \ Return from the subroutine

.LQ

 STX VIEW               \ Set the current space view to X

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR SIGHT              \ Draw the laser crosshairs

 JMP NWSTARS            \ Set up a new stardust field and return from the
                        \ subroutine using a tail call

.LOOK1

 LDA #0                 \ Set A = 0, the type number of a space view

IF _6502SP_VERSION

 JSR DOVDU19            \ Send a #SETVDU19 0 command to the I/O processor to
                        \ switch to the mode 1 palette for the space view,
                        \ which is yellow (colour 1), red (colour 2) and cyan
                        \ (colour 3)

ENDIF

 LDY QQ11               \ If the current view is not a space view, jump up to LQ
 BNE LQ                 \ to set up a new space view

 CPX VIEW               \ If the current view is already of type X, jump to LO2
 BEQ LO2                \ to return from the subroutine (as LO2 contains an RTS)

 STX VIEW               \ Change the current space view to X

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR FLIP               \ Swap the x- and y-coordinates of all the stardust
                        \ particles

 JSR WPSHPS             \ Wipe all the ships from the scanner

                        \ And fall through into SIGHT to draw the laser
                        \ crosshairs
.SIGHT

 LDY VIEW               \ Fetch the laser power for our new view, and if it is
 LDA LASER,Y            \ zero (i.e. there is no laser fitted to this view),
 BEQ LO2                \ jump to LO2 to return from the subroutine (as LO2
                        \ contains an RTS)

IF _6502SP_VERSION

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow in the space view

ENDIF

 LDA #128               \ Set QQ19 to the x-coordinate of the centre of the
 STA QQ19               \ screen

 LDA #Y-24              \ Set QQ19+1 to the y-coordinate of the centre of the
 STA QQ19+1             \ screen, minus 24 (because TT15 will add 24 to the
                        \ coordinate when it draws the crosshairs)

 LDA #20                \ Set QQ19+2 to size 20 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _DISC_VERSION

 JSR TT15               \ Call TT15 to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen

ELIF _6502SP_VERSION

 JSR TT15b              \ Call TT15b to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen, in the current
                        \ colour (yellow)

ENDIF

 LDA #10                \ Set QQ19+2 to size 10 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _DISC_VERSION

 JMP TT15               \ Call TT15 to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ELIF _6502SP_VERSION

 JMP TT15b              \ Call TT15b to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ENDIF

