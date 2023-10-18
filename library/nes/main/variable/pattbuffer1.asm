\ ******************************************************************************
\
\       Name: pattBuffer1
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Pattern buffer for colour 1 (1 bit per pixel) that gets sent to
\             the PPU during VBlank
\
\ ******************************************************************************

.pattBuffer1

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)

