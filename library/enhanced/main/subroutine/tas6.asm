\ ******************************************************************************
\
\       Name: TAS6
\       Type: Subroutine
IF NOT(_DEMO_VERSION)
\   Category: Maths (Geometry)
ELIF _DEMO_VERSION
\   Category: Demo
ENDIF
\    Summary: Negate the vector in XX15 so it points in the opposite direction
IF _DEMO_VERSION
\  Deep dive: The Elite Demonstration Disc
ENDIF
\
IF _DEMO_VERSION
\ ------------------------------------------------------------------------------
\
\ This routine has been copied from the disc version of Elite.
\
ENDIF
\ ******************************************************************************

.TAS6

 LDA XX15               \ Reverse the sign of the x-coordinate of the vector in
 EOR #%10000000         \ XX15
 STA XX15

 LDA XX15+1             \ Then reverse the sign of the y-coordinate
 EOR #%10000000
 STA XX15+1

 LDA XX15+2             \ And then the z-coordinate, so now the XX15 vector is
 EOR #%10000000         \ pointing in the opposite direction
 STA XX15+2

 RTS                    \ Return from the subroutine

