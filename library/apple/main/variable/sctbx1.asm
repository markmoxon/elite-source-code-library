\ ******************************************************************************
\
\       Name: SCTBX1
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a pixel x-coordinate to the bit number
\             within the pixel row byte that corresponds to this pixel
IF _APPLE_VERSION
\  Deep dive: Drawing pixels in the Apple II version
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _MASTER_VERSION
\ This routine is not used in this version of Elite. It is left over from the
\ Apple II version.
\
ELIF _APPLE_VERSION
\ The SCTBX1 and SCTBX2 tables can be used to convert a pixel x-coordinate into
\ the byte number and bit number within that byte of the pixel in screen memory.
\
\ Given a pixel x-coordinate X in the range 0 to 255, the tables split this into
\ factors of 7, as follows:
\
\   X = (7 * SCTBX2,X) + SCTBX1,X - 8
\
\ Because each byte in screen memory contains seven pixels, this means SCTBX2,X
\ is the byte number on the pixel row. And because the seven pixel bits inside
\ that byte are ordered on-screen as bit 0, then bit 1, then bit 2 up to bit 6,
\ SCTBX1,X is the bit number within that byte.
\
ENDIF
\ ******************************************************************************

.SCTBX1

FOR I%, 0, 255

 EQUB (I% + 8) MOD 7

NEXT

