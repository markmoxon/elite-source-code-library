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
\ various places in the code to scale the value in A. This scaling can be
\ changed by changing these routines (for example, by changing an RTS to an LSR
\ A). This code is left over from the conversion to other platforms, where
\ the scale factor might need to be different.
\
\ The original source contains the comment "SCALE Scans by 3/4 to fit in".
\
\ ******************************************************************************

.SCALEY

 LSR A                  \ Halve the value in A

