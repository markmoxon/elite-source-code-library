\ ******************************************************************************
\
\       Name: COMPAS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the compass
\
\ ******************************************************************************

.COMPAS

 JSR DOT                \ Call DOT to redraw (i.e. remove) the current compass
                        \ dot

 LDA SSPR               \ If we are inside the space station safe zone, jump to
 BNE SP1                \ SP1 to draw the space station on the compass

 JSR SPS1               \ Otherwise we need to draw the planet on the compass,
                        \ so first call SPS1 to calculate the vector to the
                        \ planet and store it in XX15

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Minor

 JMP SP2                \ Jump to SP2 to draw XX15 on the compass, returning
                        \ from the subroutine using a tail call

ELIF _6502SP_VERSION

 BRA SP2                \ Jump to SP2 to draw XX15 on the compass, returning
                        \ from the subroutine using a tail call

ENDIF

