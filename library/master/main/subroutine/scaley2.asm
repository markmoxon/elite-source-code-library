\ ******************************************************************************
\
\       Name: SCALEY2
\       Type: Subroutine
\   Category: Maths (Geometry)
IF _MASTER_VERSION \ Comment
\    Summary: Scale the y-coordinate in A (leave it unchanged)
ELIF _APPLE_VERSION
\    Summary: Scale the y-coordinate in A to 0.75 * A
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This routine (and the related SCALEY and SCALEX routines) are called from
\ various places in the code to scale the value in A. This code is different in
\ the Apple II and BBC Master versions, and allows coordinates to be scaled
\ correctly on different platforms.
\
\ The original source contains the comment "SCALE Scans by 3/4 to fit in".
\
\ ******************************************************************************

.SCALEY2

IF _APPLE_VERSION

 STA T3                 \ Set A = (A / 4) - A
 LSR A                  \       = -0.75 * A
 LSR A
 SEC
 SBC T3

 EOR #&FF               \ Negate A, so A = 0.75 * A
 ADC #1

ENDIF

 RTS                    \ Return from the subroutine

