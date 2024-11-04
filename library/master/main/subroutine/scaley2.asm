\ ******************************************************************************
\
\       Name: SCALEY2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Scale the y-coordinate in A
\
\ ------------------------------------------------------------------------------
\
\ This routine (and the related SCALEY and SCALEX routines) are called from
\ various places in the code to scale the value in A. This code is different in
\ the Apple II and BBC Master versions, and allows coordinates to be scaled
\ correctly on different platforms.
\
\ ******************************************************************************

.SCALEY2

IF _APPLE_VERSION

 STA T3                 \ ???
 LSR A
 LSR A
 SEC
 SBC T3
 EOR #&FF
 ADC #1

ENDIF

 RTS                    \ Return from the subroutine

