\ ******************************************************************************
\
\       Name: SCTBH2
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of the bottom pixel line in that character row (high byte)
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

.SCTBH2

 EQUB HI(&2000 + &1C00)
 EQUB HI(&2080 + &1C00)
 EQUB HI(&2100 + &1C00)
 EQUB HI(&2180 + &1C00)
 EQUB HI(&2200 + &1C00)
 EQUB HI(&2280 + &1C00)
 EQUB HI(&2300 + &1C00)
 EQUB HI(&2380 + &1C00)
 EQUB HI(&2028 + &1C00)
 EQUB HI(&20A8 + &1C00)
 EQUB HI(&2128 + &1C00)
 EQUB HI(&21A8 + &1C00)
 EQUB HI(&2228 + &1C00)
 EQUB HI(&22A8 + &1C00)
 EQUB HI(&2328 + &1C00)
 EQUB HI(&23A8 + &1C00)
 EQUB HI(&2050 + &1C00)
 EQUB HI(&20D0 + &1C00)
 EQUB HI(&2150 + &1C00)
 EQUB HI(&21D0 + &1C00)
 EQUB HI(&2250 + &1C00)
 EQUB HI(&22D0 + &1C00)
 EQUB HI(&2350 + &1C00)
 EQUB HI(&23D0 + &1C00)

