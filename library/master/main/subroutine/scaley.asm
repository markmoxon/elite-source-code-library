\ ******************************************************************************
\
\       Name: SCALEY
\       Type: Subroutine
\   Category: Maths (Geometry)
IF _MASTER_VERSION \ Comment
\    Summary: Scale the y-coordinate in A to 0.5 * A
ELIF _APPLE_VERSION
\    Summary: Scale the y-coordinate in A to 0.375 * A
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This routine (and the related SCALEY2 and SCALEX routines) are called from
\ various places in the code to scale the value in A. This code is different in
\ the Apple II and BBC Master versions, and allows coordinates to be scaled
\ correctly on different platforms.
\
\ ******************************************************************************

.SCALEY

 LSR A                  \ Halve the value in A

IF _MASTER_VERSION \ Comment

                        \ Fall through into SCALEY2 to return from the
                        \ subroutine

ELIF _APPLE_VERSION

                        \ Fall through into SCALEY2 to scale the y-coordinate in
                        \ A to 0.75 * A, to give a final scaling of 0.375 * A

ENDIF

