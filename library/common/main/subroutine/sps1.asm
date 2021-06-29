\ ******************************************************************************
\
\       Name: SPS1
\       Type: Subroutine
\   Category: Maths (Geometry)
IF NOT(_ELITE_A_VERSION)
\    Summary: Calculate the vector to the planet and store it in XX15
ELIF _ELITE_A_VERSION
\    Summary: Calculate the vector to the planet, sun or station and store it in
\             XX15
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _ELITE_A_VERSION
\ Arguments:
\
\   Y                   Determines the object whose vector we are calculating:
\
\                         * 0 = calculate the vector to the planet
\
\                         * NI% = calculate the vector to the sun/space station
\
ENDIF
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

 LDX #0                 \ Copy the two high bytes of the planet/sun/station's
 JSR SPS3               \ x-coordinate into K3(2 1 0), separating out the sign
                        \ bit into K3+2

 JSR SPS3               \ Copy the two high bytes of the planet/sun/station's
                        \ y-coordinate into K3(5 4 3), separating out the sign
                        \ bit into K3+5

 JSR SPS3               \ Copy the two high bytes of the planet/sun/station's
                        \ z-coordinate into K3(8 7 6), separating out the sign
                        \ bit into K3+8

ENDIF

                        \ Fall through into TAS2 to build XX15 from K3

