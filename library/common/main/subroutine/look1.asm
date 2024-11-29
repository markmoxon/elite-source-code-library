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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The space view to set:
\
\                         * 0 = front
\                         * 1 = rear
\                         * 2 = left
\                         * 3 = right
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LO2                 Contains an RTS
\
\ ******************************************************************************

.LO2

 RTS                    \ Return from the subroutine

.LQ

IF NOT(_NES_VERSION)

 STX VIEW               \ Set the current space view to X

 JSR TT66               \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR SIGHT              \ Draw the laser crosshairs

ELIF _NES_VERSION

 JSR SendSpaceViewToPPU \ Set a new space view, clear the screen, copy the
                        \ nametable buffers and configure the PPU for the new
                        \ view

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: Group A: The Master has a unique lightning bolt effect for the energy bomb

 LDA BOMB               \ If our energy bomb has been set off, then BOMB will be
 BPL P%+5               \ negative, so this skips the following instruction if
                        \ our energy bomb is not going off

 JSR BOMBOFF            \ Our energy bomb is going off, so call BOMBOFF to draw
                        \ the zig-zag lightning bolt

ENDIF

 JMP NWSTARS            \ Set up a new stardust field and return from the
                        \ subroutine using a tail call

.LOOK1

 LDA #0                 \ Set A = 0, the type number of a space view

IF _6502SP_VERSION \ Screen

 JSR DOVDU19            \ Send a #SETVDU19 0 command to the I/O processor to
                        \ switch to the mode 1 palette for the space view,
                        \ which is yellow (colour 1), red (colour 2) and cyan
                        \ (colour 3)

ELIF _MASTER_VERSION

 JSR DOVDU19            \ Switch to the mode 1 palette for the space view,
                        \ which is yellow (colour 1), red (colour 2) and cyan
                        \ (colour 3)

ELIF _C64_VERSION

 JSR DOVDU19            \ Switch to the palette for the space view, though this
                        \ doesn't actually do anything in this version of Elite

ENDIF

 LDY QQ11               \ If the current view is not a space view, jump up to LQ
 BNE LQ                 \ to set up a new space view

 CPX VIEW               \ If the current view is already of type X, jump to LO2
 BEQ LO2                \ to return from the subroutine (as LO2 contains an RTS)

IF NOT(_NES_VERSION)

 STX VIEW               \ Change the current space view to X

 JSR TT66               \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

ELIF _NES_VERSION

 JSR SetSpaceViewInNMI  \ Change the current space view to X and configure the
                        \ NMI to send both bitplanes to the PPU during VBlank

ENDIF

 JSR FLIP               \ Swap the x- and y-coordinates of all the stardust
                        \ particles and redraw the stardust field

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: See group A

 LDA BOMB               \ If our energy bomb has been set off, then BOMB will be
 BPL P%+5               \ negative, so this skips the following instruction if
                        \ our energy bomb is not going off

 JSR BOMBOFF            \ Our energy bomb is going off, so call BOMBOFF to draw
                        \ the zig-zag lightning bolt

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

 JSR WPSHPS             \ Wipe all the ships from the scanner and mark them all
                        \ as not being shown on-screen

ELIF _ELITE_A_6502SP_PARA

 JSR WPSHPSS            \ Wipe all the ships from the scanner and mark them all
                        \ as not being shown on-screen

ENDIF

IF NOT(_NES_VERSION)

                        \ And fall through into SIGHT to draw the laser
                        \ crosshairs

ELIF _NES_VERSION

 JMP WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank) and return from the subroutine using a
                        \ tail call

ENDIF

