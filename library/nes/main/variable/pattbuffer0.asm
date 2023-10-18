\ ******************************************************************************
\
\       Name: pattBuffer0
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Pattern buffer for colour 0 (1 bit per pixel) that gets sent to
\             the PPU during VBlank
\
\ ******************************************************************************

.pattBuffer0

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)

