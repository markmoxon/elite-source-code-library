\ ******************************************************************************
\
\       Name: ECBT
\       Type: Variable
\   Category: Dashboard
\    Summary: The character bitmap for the E.C.M. indicator bulb
\
\ ------------------------------------------------------------------------------
\
\ The character bitmap for the E.C.M. indicator's "E" bulb that gets displayed
\ on the dashboard.
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Comment
\ The E.C.M. indicator uses the first 5 rows of the space station's "S" bulb
\ below, as the bottom 5 rows of the "E" match the top 5 rows of the "S".
\
\ Each pixel is in mode 5 colour 2 (%10), which is yellow/white.
\
ELIF _ELECTRON_VERSION
\ The E.C.M. indicator uses the first 5 rows of the space station's "S" bulb
\ below, as the bottom 5 rows of the "E" match the top 5 rows of the "S".
\
\ Each pixel is a white mode 4 pixel.
\
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ The bulb is four pixels wide, so it covers two mode 2 character blocks, one
\ containing the left half of the "E", and the other the right half, which are
\ displayed next to each other. Each pixel is in mode 2 colour 7 (%1111), which
\ is white.
\
ELIF _APPLE_VERSION
\ The E.C.M. indicator uses the first 5 rows of the space station's "S" bulb
\ below, as the bottom 5 rows of the "E" match the top 5 rows of the "S".
\
\ The bulb is seven pixels wide, so it fits into one character block, along with
\ the colour palette in bit 7.
\
ENDIF
\ ******************************************************************************

.ECBT

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The "E" indicator bulb on the dashboard is four pixels wide in the advanced versions, while it is only three pixels wide in the cassette and disc versions. It is seven pixels wide in the Electron version, though the latter is in monochrome mode 4, so this is equivalent to 3.5 pixels in the colour versions

 EQUB %11100000         \ x x x .
 EQUB %11100000         \ x x x .
 EQUB %10000000         \ x . . .
                        \ x x x .
                        \ x x x .
                        \ x . . .
                        \ x x x .
                        \ x x x .

ELIF _ELECTRON_VERSION

 EQUB %11111110         \ x x x x x x x x .
 EQUB %11111110         \ x x x x x x x x .
 EQUB %11100000         \ x x x . . . . . .
                        \ x x x x x x x x .
                        \ x x x x x x x x .
                        \ x x x . . . . . .
                        \ x x x x x x x x .
                        \ x x x x x x x x .

ELIF _6502SP_VERSION OR _MASTER_VERSION

                        \ Left half of the "E" bulb
                        \
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x
 EQUB %10101010         \ x .
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x
 EQUB %10101010         \ x .
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x

                        \ Right half of the "E" bulb
                        \
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x
 EQUB %00000000         \ . .
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x
 EQUB %00000000         \ . .
 EQUB %11111111         \ x x
 EQUB %11111111         \ x x

                        \ Combined "E" bulb
                        \
                        \ x x x x
                        \ x x x x
                        \ x . . .
                        \ x x x x
                        \ x x x x
                        \ x . . .
                        \ x x x x
                        \ x x x x

ELIF _APPLE_VERSION

 EQUB %01111111         \ x x x x x x x
 EQUB %01111111         \ x x x x x x x
 EQUB %00000111         \ x x x . . . .

ENDIF

