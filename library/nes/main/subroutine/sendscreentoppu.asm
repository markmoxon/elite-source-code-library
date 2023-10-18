\ ******************************************************************************
\
\       Name: SendScreenToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Update the screen with the contents of the buffers
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SendScreenToPPU+4   Re-entry point following the call to SendPalettesToPPU
\                       at the start of the routine
\
\ ******************************************************************************

.SendScreenToPPU

 LDA updatePaletteInNMI \ If updatePaletteInNMI is non-zero, then jump up to
 BNE SendPalettesToPPU  \ SendPalettesToPPU to send the palette data in XX3 to
                        \ the PPU, before continuing with the next instruction

 JSR SendBuffersToPPU   \ Send the contents of the nametable and pattern buffers
                        \ to the PPU to update the screen

 JSR SetPPURegisters    \ Set PPU_CTRL, PPU_ADDR and PPU_SCROLL for the current
                        \ hidden bitplane

 LDA cycleCount         \ Add 100 (&0064) to cycleCount
 CLC
 ADC #&64
 STA cycleCount
 LDA cycleCount+1
 ADC #&00
 STA cycleCount+1

 BMI upsc1              \ If the result is negative, jump to upsc1 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JSR ClearBuffers       \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so call
                        \ ClearBuffers to reset the buffers for both bitplanes

.upsc1

 LDA #%00011110         \ Configure the PPU by setting PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (i.e. not monochrome)
                        \   * Bit 1 set   = show leftmost 8 pixels of background
                        \   * Bit 2 set   = show sprites in leftmost 8 pixels
                        \   * Bit 3 set   = show background
                        \   * Bit 4 set   = show sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

 RTS                    \ Return from the subroutine

