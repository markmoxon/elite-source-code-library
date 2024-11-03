\ ******************************************************************************
\
\       Name: SCALEY
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Scale the y-coordinate in A
\
\ ------------------------------------------------------------------------------
\
\ This routine (and the related SCALEY2 and SCALEX routines) are called from
\ various places in the code to scale the value in A. This code is different in
\ the Apple II and BBC Master versions, and allows coordinates to be scaled
\ correctly on different platforms.
\
\ The original source contains the comment "SCALE Scans by 3/4 to fit in".
\
\ ******************************************************************************

.SCALEY

 LSR A                  \ Halve the value in A

