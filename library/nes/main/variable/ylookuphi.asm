\ ******************************************************************************
\
\       Name: yLookupHi
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting pixel y-coordinate to tile number
\             (high byte)
\
\ ------------------------------------------------------------------------------
\
\ The NES screen mode is made up of 8x8-pixel tiles, with 32 tiles (256 pixels)
\ across the screen, and either 30 tiles (240 pixels) or 28 tiles (224 pixels)
\ vertically, for PAL or NTSC.
\
\ This lookup table converts a pixel y-coordinate into the number of the first
\ tile on the row containing the pixel, if we assume tiles are numbered from 1
\ at the top-left, and counting across and then down.
\
\ ******************************************************************************

.yLookupHi

 FOR I%, 16, 239

  EQUB HI((I% DIV 8) * 32 + 1)

 NEXT

