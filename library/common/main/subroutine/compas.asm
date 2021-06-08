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

IF NOT(_ELITE_A_VERSION)

 LDA SSPR               \ If we are inside the space station safe zone, jump to
 BNE SP1                \ SP1 to draw the space station on the compass

 JSR SPS1               \ Otherwise we need to draw the planet on the compass,
                        \ so first call SPS1 to calculate the vector to the
                        \ planet and store it in XX15

ELIF _ELITE_A_VERSION

 LDY #&25               \ AJD
 LDA &0320
 BNE l_station
 LDY &9F	\ finder

.l_station

 JSR SPS1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Minor

 JMP SP2                \ Jump to SP2 to draw XX15 on the compass, returning
                        \ from the subroutine using a tail call

ELIF _6502SP_VERSION

 BRA SP2                \ Jump to SP2 to draw XX15 on the compass, returning
                        \ from the subroutine using a tail call

ELIF _ELITE_A_VERSION

                        \ Fall through into SP2 to draw XX15 on the compass

ENDIF

