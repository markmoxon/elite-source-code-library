\ ******************************************************************************
\
\       Name: SCALEY
\       Type: Subroutine
\   Category: Maths (Geometry)
IF _MASTER_VERSION
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
IF _MASTER_VERSION
\ In the Master version, the only scaling routine that does anything is SCALEY,
\ which halves the y-coordinates in the Long-range Chart (as the galaxy is half
\ as tall as it is wide). The other routines are left over from the Apple II
\ version, which uses them to scale the system charts to fit into its smaller
\ screen size.
\
ELIF _APPLE_VERSION
\ In the Apple version, the scaling routines scale screen coordinates in the
\ system charts by 3/4 in each direction. This enables the charts to fit into
\ the smaller screen size  when compared to the BBC Micro versions, while still
\ leaving the dashboard on-screen (the Commodore 64 version also has a smaller
\ screen, but it removes the dashboard from the screen to make more room).
\
\ The scaling routines do the following:
\
\   * SCALEX scales an x-coordinate to 32 + 0.75 * x
\
\   * SCALEY scales a y-coordinate to 0.375 * y
\
\   * SCALEY2 scales a y-coordinate to 0.75 * y
\
ENDIF
\ ******************************************************************************

.SCALEY

 LSR A                  \ Halve the value in A

IF _MASTER_VERSION

                        \ Fall through into SCALEY2 to return from the
                        \ subroutine

ELIF _APPLE_VERSION

                        \ Fall through into SCALEY2 to scale the y-coordinate in
                        \ A to 0.75 * A, to give a final scaling of 0.375 * A

ENDIF

