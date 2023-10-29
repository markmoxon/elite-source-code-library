\ ******************************************************************************
\
\       Name: yLookupLo
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting pixel y-coordinate to tile number
\             (low byte)
\
\ ------------------------------------------------------------------------------
\
\ The NES screen mode is made up of 8x8-pixel tiles, with 32 tiles (256 pixels)
\ across the screen, and either 30 tiles (240 pixels) or 28 tiles (224 pixels)
\ vertically, for PAL or NTSC.
\
\ This lookup table converts a pixel y-coordinate into the number of the first
\ tile on the row containing the pixel. Pixel coordinate (0, 0) is mapped to the
\ top-left pixel of the third row of tiles in the nametable, and the first
\ column of tiles is at column 1 rather than 0 (as the screen is scrolled
\ horizontally by 8 pixels via PPU_SCROLL), so pixel y-coordinates 0 to 7 are
\ mapped to tile 65 (i.e. 2 * 32 + 1), pixel y-coordinates 8 to 15 are mapped to
\ tile 97 (i.e. 3 * 32 + 1), and so on.
\
\ ******************************************************************************

.yLookupLo

 FOR I%, 16, 239

  EQUB LO((I% DIV 8) * 32 + 1)

 NEXT

