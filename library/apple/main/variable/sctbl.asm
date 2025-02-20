\ ******************************************************************************
\
\       Name: SCTBL
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of the top or bottom pixel line in that character row (low byte)
\  Deep dive: Drawing pixels in the Apple II version
\
\ ------------------------------------------------------------------------------
\
\ The character rows in screen memory for the Apple II high-res screen are not
\ stored in the order in which they appear. The SCTBL, SCTBH and SCTBH2 tables
\ provide a lookup for the address of the start of each character row.
\
\ Also, the pixel rows within each character row are interleaved, so each pixel
\ row appears &400 bytes after the previous pixel row. The address of pixel row
\ n within character row Y is stored at the address given in the Y-th entry of
\ (SCTBH SCTBL), plus n * &400, so the addresses are as follows:
\
\   * Pixel row 0 is at the Y-th entry from (SCTBH SCTBL)
\   * Pixel row 1 is at the Y-th entry from (SCTBH SCTBL) + &400
\   * Pixel row 2 is at the Y-th entry from (SCTBH SCTBL) + &800
\   * Pixel row 3 is at the Y-th entry from (SCTBH SCTBL) + &C00
\   * Pixel row 4 is at the Y-th entry from (SCTBH SCTBL) + &1000
\   * Pixel row 5 is at the Y-th entry from (SCTBH SCTBL) + &1400
\   * Pixel row 6 is at the Y-th entry from (SCTBH SCTBL) + &1800
\   * Pixel row 7 is at the Y-th entry from (SCTBH SCTBL) + &1C00
\
\ To make life easier, the table at SCTBH2 contains the high byte for the final
\ row, where the high byte has &1C00 added to the address.
\
\ ******************************************************************************

.SCTBL

 EQUB LO(&2000)
 EQUB LO(&2080)
 EQUB LO(&2100)
 EQUB LO(&2180)
 EQUB LO(&2200)
 EQUB LO(&2280)
 EQUB LO(&2300)
 EQUB LO(&2380)
 EQUB LO(&2028)
 EQUB LO(&20A8)
 EQUB LO(&2128)
 EQUB LO(&21A8)
 EQUB LO(&2228)
 EQUB LO(&22A8)
 EQUB LO(&2328)
 EQUB LO(&23A8)
 EQUB LO(&2050)
 EQUB LO(&20D0)
 EQUB LO(&2150)
 EQUB LO(&21D0)
 EQUB LO(&2250)
 EQUB LO(&22D0)
 EQUB LO(&2350)
 EQUB LO(&23D0)

