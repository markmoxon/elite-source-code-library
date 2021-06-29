\ ******************************************************************************
\
\       Name: LAUN
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Make the launch sound and draw the launch tunnel
\
\ ------------------------------------------------------------------------------
\
\ This is shown when launching from or docking with the space station.
\
\ ******************************************************************************

.LAUN

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 JSR NOISE              \ of the ship launching from the station

ELIF _MASTER_VERSION

 LDY #8                 \ Call the NOISE routine with Y = 8 to make the sound
 JSR NOISE              \ of the ship launching from the station

ELIF _ELITE_A_VERSION

 JSR n_sound30          \ Call n_sound30 to make the sound of a missile being
                        \ launched

ENDIF

 LDA #8                 \ Set the step size for the launch tunnel rings to 8, so
                        \ there are fewer sections in the rings and they are
                        \ quite polygonal (compared to the step size of 4 used
                        \ in the much rounder hyperspace rings)

                        \ Fall through into HFS2 to draw the launch tunnel rings

