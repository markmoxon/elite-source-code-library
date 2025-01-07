\ ******************************************************************************
\
\       Name: SCALEX
\       Type: Subroutine
\   Category: Maths (Geometry)
IF _MASTER_VERSION \ Comment
\    Summary: Scale the x-coordinate in A (leave it unchanged)
ELIF _APPLE_VERSION
\    Summary: Scale the x-coordinate in A to 32 + 0.75 * A
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This routine (and the related SCALEY and SCALEY2 routines) are called from
\ various places in the code to scale the value in A. This code is different in
\ the Apple II and BBC Master versions, and allows coordinates to be scaled
\ correctly on different platforms.
\
\ ******************************************************************************

.SCALEX

IF _APPLE_VERSION

 JSR SCALEY2            \ ???
 ADC #32

ENDIF

 RTS                    \ Return from the subroutine

