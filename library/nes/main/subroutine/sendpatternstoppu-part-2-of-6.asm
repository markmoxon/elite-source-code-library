\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 2 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Configure variables for sending data to the PPU one pattern at a
\             time with checks
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.spat6

 LDA patternCounter     \ Set (addr A) = patternCounter
 LDX #0
 STX addr

 STX dataForPPU         \ Zero the low byte of dataForPPU(1 0)
                        \
                        \ We set the high byte in part 1, so dataForPPU(1 0) now
                        \ contains the address of the pattern buffer for this
                        \ bitplane

 ASL A                  \ Set (addr X) = (addr A) << 4
 ROL addr               \              = patternCounter * 16
 ASL A
 ROL addr
 ASL A
 ROL addr
 ASL A
 TAX

 LDA addr               \ Set (A X) = (ppuPatternTableHi 0) + (addr X)
 ROL A                  \         = (ppuPatternTableHi 0) + patternCounter * 16
 ADC ppuPatternTableHi  \
                        \ ppuPatternTableHi contains the high byte of the
                        \ address of the PPU pattern table to which we send
                        \ patterns; it contains HI(PPU_PATT_1), so (A X) now
                        \ contains the address in PPU pattern table 1 for
                        \ pattern number patternCounter (as there are 16 bytes
                        \ in the pattern table for each pattern)

                        \ We now set both PPU_ADDR and addr(1 0) to the
                        \ following:
                        \
                        \   * (A X)         when nmiBitplane is 0
                        \
                        \   * (A X) + 8     when nmiBitplane is 1
                        \
                        \ We add 8 in the second example to point the address to
                        \ bitplane 1, as the PPU interleaves each pattern as
                        \ 8 bytes of one bitplane followed by 8 bytes of the
                        \ other bitplane, so bitplane 1's data always appears 8
                        \ bytes after the corresponding bitplane 0 data

 STA PPU_ADDR           \ Set the high byte of PPU_ADDR to A

 STA addr+1             \ Set the high byte of addr to A

 TXA                    \ Set A = X + nmiBitplane8
 ADC nmiBitplane8       \       = X + nmiBitplane * 8
                        \
                        \ So we add 8 to the low byte when we are writing to
                        \ bit plane 1, otherwise we leave the low byte alone

 STA PPU_ADDR           \ Set the low byte of PPU_ADDR to A

 STA addr               \ Set the high byte of addr to A

                        \ So PPU_ADDR and addr(1 0) both contain the PPU
                        \ address to which we should send our pattern data for
                        \ this bitplane

 JMP spat9              \ Jump into part 3 to send pattern data to the PPU

