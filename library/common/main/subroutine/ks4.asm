\ ******************************************************************************
\
\       Name: KS4
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove the space station and replace it with the sun
\
\ ------------------------------------------------------------------------------
\
\ Remove the space station from our local bubble of universe, and replace it
\ with the sun.
\
\ ******************************************************************************

.KS4

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION

 JSR FLFLLS             \ Reset the LSO block, returns with A = 0

ELIF _ELECTRON_VERSION

 LDA #0                 \ ???

ENDIF

 STA FRIN+1             \ Set the second slot in the FRIN table to 0, which
                        \ sets this slot to empty, so when we call NWSHP below
                        \ the new sun that gets created will go into FRIN+1

 STA SSPR               \ Set the "space station present" flag to 0, as we are
                        \ no longer in the space station's safe zone

 JSR SPBLB              \ Call SPBLB to redraw the space station bulb, which
                        \ will erase it from the dashboard

 LDA #6                 \ Set the sun's y_sign to 6
 STA INWK+5

 LDA #129               \ Set A = 129, the "ship" type for the sun

 JMP NWSHP              \ Call NWSHP to set up the sun's data block and add it
                        \ to FRIN, where it will get put in the second slot as
                        \ we just cleared out the second slot, and the first
                        \ slot is already taken by the planet

