.ppuPatternTableHi

 SKIP 1                 \ High byte of the address of the PPU pattern table to
                        \ which we send patterns
                        \
                        \ This is set to HI(PPU_PATT_1) in ResetScreen and
                        \ doesn't change again, so it always points to pattern
                        \ table 1 in the PPU, as that's the only pattern table
                        \ we use for storing patterns

