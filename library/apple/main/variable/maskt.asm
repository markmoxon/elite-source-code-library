\ ******************************************************************************
\
\       Name: MASKT
\       Type: Variable
\   Category: Drawing lines
\    Summary: High-resolution pixel bytes for drawing continuous lines of solid
\             colour
\
\ ------------------------------------------------------------------------------
\
\ This table contains four bytes for each colour (the colour variables such as
\ VIOLET and RED are indexes into this table).
\
\ The first three bytes contain the values we need to store in screen memory to
\ draw a continuous line in the relevant colour; the fourth byte is ignored and
\ is zero. Bytes #0 and #1 contain the bit pattern for when the first byte is
\ placed in an even-numbered pixel byte (counting along the pixel row), while
\ bytes #1 and #2 contain the bit pattern for when the first byte is placed in
\ an odd-numbered pixel byte.
\
\ The comments show the on-off patterns that the high-resolution mode converts
\ into colours, with bit 7 removed for clarity.
\
\ ******************************************************************************

.MASKT

      \ Byte #2 Byte #1 Byte #0       Byte #0 Byte #1 Byte #2
      \ 6543210 6543210 6543210       0123456 0123456 0123456

 EQUD %000000000000000000000000     \ Black (00) in colour palette 0
                                    \ 0000000 0000000 0000000

 EQUD %010101010010101001010101     \ Violet (x0) in colour palette 0
                                    \ x0x0x0x 0x0x0x0 x0x0x0x

 EQUD %001010100101010100101010     \ Green (0x) in colour palette 0
                                    \ 0x0x0x0 x0x0x0x 0x0x0x0

 EQUD %011111110111111101111111     \ White (xx) in colour palette 0
                                    \ xxxxxxx xxxxxxx xxxxxxx

 EQUD %110101011010101011010101     \ Blue (x0) in colour palette 1
                                    \ x0x0x0x 0x0x0x0 x0x0x0x

 EQUD %101010101101010110101010     \ Red (0x) in colour palette 1
                                    \ 0x0x0x0 x0x0x0x 0x0x0x0

 EQUD %101010101010101010101010     \ Fuzzy (red/black/blue) in colour palette 1
                                    \ 0x0x0x0 0x0x0x0 0x0x0x0

