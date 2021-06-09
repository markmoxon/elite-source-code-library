\ ******************************************************************************
\
\       Name: SPS1
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the vector to the planet and store it in XX15
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SPS1+1              A BRK instruction
\
\ ******************************************************************************

.SPS1

IF NOT(_ELITE_A_VERSION)

 LDX #0                 \ Copy the two high bytes of the planet's x-coordinate
 JSR SPS3               \ into K3(2 1 0), separating out the sign bit into K3+2

 LDX #3                 \ Copy the two high bytes of the planet's y-coordinate
 JSR SPS3               \ into K3(5 4 3), separating out the sign bit into K3+5

 LDX #6                 \ Copy the two high bytes of the planet's z-coordinate
 JSR SPS3               \ into K3(8 7 6), separating out the sign bit into K3+8

ELIF _ELITE_A_VERSION

 LDX #0                 \ Copy the two high bytes of the planet's x-coordinate
 JSR SPS3               \ into K3(2 1 0), separating out the sign bit into K3+2

 JSR SPS3               \ AJD

 JSR SPS3               \ AJD

ENDIF

                        \ Fall through into TAS2 to build XX15 from K3

