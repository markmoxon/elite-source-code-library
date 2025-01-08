\ ******************************************************************************
\
\       Name: TWOS3
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Ready-made two-pixel and three-pixel bytes in white, with an extra
\             byte to cater for overflow into the next pixel byte
\
\ ------------------------------------------------------------------------------
\
\ This table contains ready-made pixel bytes for drawing a two-pixel or
\ three-pixel dash in the high-resolution screen mode on the Apple II.
\
\ The first half of the table contains two-pixel dashes, with the entry at
\ TWOS3+X containing a two-pixel dash starting at pixel X within the first pixel
\ byte.
\
\ The second half of the table contains three-pixel dashes, with the entry at
\ TWOS3+14+X containing a three-pixel dash starting at pixel X within the first
\ pixel byte.
\
\ Bit 7 in each byte is used to define the colour palette in that byte, so the
\ pixels are set in bits 0 to 6. The pixels in bits 0 to 6 appear in that order
\ on-screen (so bit 0 is on the left). The comments below show how the two bytes
\ map into the screen, with seven pixels per byte.
\
\ ******************************************************************************

.TWOS3

 EQUW %0000000000000011     \ xx00000 0000000
 EQUW %0000000000000110     \ 0xx0000 0000000
 EQUW %0000000000001100     \ 00xx000 0000000
 EQUW %0000000000011000     \ 000xx00 0000000
 EQUW %0000000000110000     \ 0000xx0 0000000
 EQUW %0000000001100000     \ 00000xx 0000000
 EQUW %0000000101000000     \ 000000x x000000

 EQUW %0000000000000111     \ xxx0000 0000000
 EQUW %0000000000001110     \ 0xxx000 0000000
 EQUW %0000000000011100     \ 00xxx00 0000000
 EQUW %0000000000111000     \ 000xxx0 0000000
 EQUW %0000000001110000     \ 0000xxx 0000000
 EQUW %0000000101100000     \ 00000xx x000000
 EQUW %0000001101000000     \ 000000x xx00000

