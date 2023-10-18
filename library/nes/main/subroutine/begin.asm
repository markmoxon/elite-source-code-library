\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Start and end
\    Summary: Run through the NES initialisation process, reset the variables
\             and start the game
\
\ ******************************************************************************

.BEGIN

 SEI                    \ Disable interrupts

 CLD                    \ Clear the decimal flag, so we're not in decimal mode
                        \ (this has no effect on the NES, as BCD mode is
                        \ disabled in the 2A03 CPU, but we do this to ensure
                        \ compatibility with 6502-based debuggers)

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDX #0                 \ Set startupDebug = 0 (though this value is never read,
 STX startupDebug       \ so this has no effect)

 LDA #%00010000         \ Configure the PPU by setting PPU_CTRL as follows:
 STA PPU_CTRL           \
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 clear = disable VBlank NMI generation

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 LDA #%00000000         \ Configure the PPU by setting PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (not monochrome)
                        \   * Bit 1 clear = hide leftmost 8 pixels of background
                        \   * Bit 2 clear = hide sprites in leftmost 8 pixels
                        \   * Bit 3 clear = hide background
                        \   * Bit 4 clear = hide sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

                        \ We now wait for three VBlanks to pass to ensure that
                        \ the PPU has stabilised after starting up

.sper1

 LDA PPU_STATUS         \ Wait for the first VBlank to pass, which will set bit
 BPL sper1              \ 7 of PPU_STATUS (and reading PPU_STATUS clears bit 7,
                        \ ready for the next VBlank)

.sper2

 LDA PPU_STATUS         \ Wait for the second VBlank to pass
 BPL sper2

.sper3

 LDA PPU_STATUS         \ Wait for the third VBlank to pass
 BPL sper3

 LDA #0                 \ Set K% = 0 (English) to set as the default highlighted
 STA K%                 \ language on the Start screen (see the ChooseLanguage
                        \ routine)

 LDA #60                \ Set K%+1 = 60 to use as the value of the third counter
 STA K%+1               \ when deciding how long to wait on the Start screen
                        \ before auto-playing the demo (see the ChooseLanguage
                        \ routine)

                        \ Fall through into ResetToStartScreen to reset memory
                        \ and show the Start screen

