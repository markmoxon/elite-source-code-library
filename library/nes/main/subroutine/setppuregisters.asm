\ ******************************************************************************
\
\       Name: SetPPURegisters
\       Type: Subroutine
\   Category: PPU
\    Summary: Set PPU_CTRL, PPU_ADDR and PPU_SCROLL for the current hidden
\             bitplane
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.SetPPURegisters

 LDX #%10010000         \ Set X to use as the value of PPU_CTRL for when
                        \ hiddenBitplane is 1:
                        \
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 set   = enable VBlank NMI generation

 LDA hiddenBitplane     \ If hiddenBitplane is non-zero (i.e. 1), skip the
 BNE resp1              \ following

 LDX #%10010001         \ Set X to use as the value of PPU_CTRL for when
                        \ hiddenBitplane is 0:
                        \
                        \   * Bits 0-1    = base nametable address %01 (&2400)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 set   = enable VBlank NMI generation

.resp1

 STX PPU_CTRL           \ Configure the PPU with the above value of PPU_CTRL,
                        \ according to the hidden bitplane, so we set:
                        \
                        \   * Nametable 0 when hiddenBitplane = 1
                        \
                        \   * Nametable 1 when hiddenBitplane = 0
                        \
                        \ This makes sure that the screen shows the nametable
                        \ for the visible bitplane, and not the hidden bitplane

 STX ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 LDA #&20               \ If hiddenBitplane = 0 then set A = &24, otherwise set
 LDX hiddenBitplane     \ A = &20, to use as the high byte of the PPU_ADDR
 BNE resp2              \ address
 LDA #&24

.resp2

 STA PPU_ADDR           \ Set PPU_ADDR to point to the nametable address that we
 LDA #&00               \ just configured:
 STA PPU_ADDR           \
                        \   * &2000 (nametable 0) when hiddenBitplane = 1
                        \
                        \   * &2400 (nametable 1) when hiddenBitplane = 0
                        \
                        \ So we now flush the pipeline for the nametable that we
                        \ are showing on-screen, to avoid any corruption

 LDA PPU_DATA           \ Read from PPU_DATA eight times to clear the pipeline
 LDA PPU_DATA           \ and reset the internal PPU read buffer
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA

 LDA #8                 \ Set the horizontal scroll to 8, so the leftmost tile
 STA PPU_SCROLL         \ on each row is scrolled around to the right side
                        \
                        \ This means that in terms of tiles, column 1 is the
                        \ left edge of the screen, then columns 2 to 31 form the
                        \ body of the screen, and column 0 is the right edge of
                        \ the screen

 LDA #0                 \ Set the vertical scroll to 0
 STA PPU_SCROLL

 RTS                    \ Return from the subroutine

