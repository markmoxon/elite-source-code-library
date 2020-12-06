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

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 JSR NOISE              \ of the ship launching from the station

 LDA #8                 \ Set the step size for the hyperspace rings to 8, so
                        \ there are fewer sections in the rings and they are
                        \ quite polygonal (compared to the step size of 4 used
                        \ in the much rounder launch rings)

                        \ Fall through into HFS2 to draw the launch tunnel rings

