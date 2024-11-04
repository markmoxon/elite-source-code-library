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

 LDY #solaun            \ Call the NOISE routine with Y = 8 to make the sound
 JSR NOISE              \ of the ship launching from the station

ELIF _C64_VERSION

 LDY #sfxwhosh          \ Call the NOISE routine with Y = sfxwhosh to make the
 JSR NOISE              \ sound of the ship launching from the station

ELIF _APPLE_VERSION

 LDY #0                 \ ???
 JSR SOHISS
 JSR SOHISS

ELIF _ELITE_A_VERSION

 JSR n_sound30          \ Call n_sound30 to make the sound of the ship launching
                        \ from the station

ENDIF

 LDA #8                 \ Set the step size for the launch tunnel rings to 8, so
                        \ there are fewer sections in the rings and they are
                        \ quite polygonal (compared to the step size of 4 used
                        \ in the much rounder hyperspace rings)

                        \ Fall through into HFS2 to draw the launch tunnel rings

