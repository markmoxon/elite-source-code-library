\ ******************************************************************************
\
\       Name: WaitFor3xVBlank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait for three VBlanks to pass
\
\ ******************************************************************************

.WaitFor3xVBlank

 LDA PPU_STATUS         \ Read the PPU_STATUS register, which clears the VBlank
                        \ latch in bit 7, so the following loops will wait for
                        \ three VBlanks in total

.wait1

 LDA PPU_STATUS         \ Wait for the first VBlank to pass, which will set bit
 BPL wait1              \ 7 of PPU_STATUS (and reading PPU_STATUS clears bit 7,
                        \ ready for the next VBlank)

.wait2

 LDA PPU_STATUS         \ Wait for the second VBlank to pass
 BPL wait2

                        \ Fall through into WaitForVBlank to wait for the third
                        \ VBlank before returning from the subroutine

