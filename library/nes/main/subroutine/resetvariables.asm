\ ******************************************************************************
\
\       Name: ResetVariables
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset all the RAM (in both the NES and cartridge), initialise all
\             the game's variables, and switch to ROM bank 0
\
\ ******************************************************************************

.ResetVariables

 LDA #%00000000         \ Configure the PPU by setting PPU_CTRL as follows:
 STA PPU_CTRL           \
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 clear = background pattern table is at &0000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 clear = disable VBlank NMI generation

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 STA PPU_MASK           \ Configure the PPU by setting PPU_MASK as follows:
                        \
                        \   * Bit 0 clear = normal colour (not monochrome)
                        \   * Bit 1 clear = hide leftmost 8 pixels of background
                        \   * Bit 2 clear = hide sprites in leftmost 8 pixels
                        \   * Bit 3 clear = hide background
                        \   * Bit 4 clear = hide sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

 STA setupPPUForIconBar \ Clear bit 7 of setupPPUForIconBar so we do nothing
                        \ when the PPU starts drawing the icon bar

 LDA #%01000000         \ Configure the APU Frame Counter as follows:
 STA APU_FC             \
                        \   * Bit 6 set = do not trigger an IRQ on the last tick
                        \
                        \   * Bit 7 clear = select the four-step sequence

 INC &C006              \ Reset the MMC1 mapper, which we can do by writing a
                        \ value with bit 7 set into any address in ROM space
                        \ (i.e. any address from &8000 to &FFFF)
                        \
                        \ The INC instruction does this in a more efficient
                        \ manner than an LDA/STA pair, as it:
                        \
                        \   * Fetches the contents of address &C006, which
                        \     contains the high byte of the JMP destination
                        \     in the JMP BEGIN instruction, i.e. the high byte
                        \     of BEGIN, which is &C0
                        \
                        \   * Adds 1, to give &C1
                        \
                        \   * Writes the value &C1 back to address &C006
                        \
                        \ &C006 is in the ROM space and &C1 has bit 7 set, so
                        \ the INC does all that is required to reset the mapper,
                        \ in fewer cycles and bytes than an LDA/STA pair
                        \
                        \ Resetting MMC1 maps bank 7 to &C000 and enables the
                        \ bank at &8000 to be switched, so this instruction
                        \ ensures that bank 7 is present

 LDA PPU_STATUS         \ Read the PPU_STATUS register, which clears the VBlank
                        \ latch in bit 7, so the following loops will wait for
                        \ three VBlanks in total

.resv1

 LDA PPU_STATUS         \ Wait for the first VBlank to pass, which will set bit
 BPL resv1              \ 7 of PPU_STATUS (and reading PPU_STATUS clears bit 7,
                        \ ready for the next VBlank)

.resv2

 LDA PPU_STATUS         \ Wait for the second VBlank to pass
 BPL resv2

.resv3

 LDA PPU_STATUS         \ Wait for the third VBlank to pass
 BPL resv3

                        \ We now zero the RAM in the NES, as follows:
                        \
                        \   * Zero page from &0000 to &00FF
                        \
                        \   * The rest of RAM from &0300 to &05FF
                        \
                        \ This clears all of the NES's built-in RAM except for
                        \ page 1, which is used for the stack

 LDA #0                 \ Set A to zero so we can poke it into memory

 TAX                    \ Set X to 0 to use as an index counter as we loop
                        \ through zero page

.resv4

 STA ZP,X               \ Zero the X-th byte of zero page at ZP

 INX                    \ Increment the byte counter

 BNE resv4              \ Loop back until we have zeroed the whole of zero page
                        \ from &0000 to &00FF

 LDA #&03               \ Set SC(1 0) = &0300
 STA SC+1
 LDA #&00
 STA SC

 TXA                    \ Set A = 0 once again so we can poke it into memory

 LDX #3                 \ We now zero three pages of memory at &0300, &0400 and
                        \ &0500, so set a page counter in X

 TAY                    \ Set Y = 0 to use as an index counter for each page of
                        \ memory

.resv5

 STA (SC),Y             \ Zero the Y-th byte of the page at SC(1 0)

 INY                    \ Increment the byte counter

 BNE resv5              \ Loop back until we have zeroed the whole page of
                        \ memory at SC(1 0)

 INC SC+1               \ Increment the high byte of SC(1 0) so it points at the
                        \ next page of memory

 DEX                    \ Decrement the page counter

 BNE resv5              \ Loop back until we have zeroed three pages of memory
                        \ from &0300 to &05FF

 JSR SetupMMC1          \ Configure the MMC1 mapper and page ROM bank 0 into
                        \ memory at &8000

 JSR ResetMusic         \ Reset the current tune to 0 and stop the music

 LDA #%10000000         \ Set A = 0 and set the C flag
 ASL A

 JSR ResetScreen_b3     \ Reset the screen by clearing down the PPU, setting
                        \ all colours to black, and resetting the screen-related
                        \ variables

 JSR SetDrawingPlaneTo0 \ Set the drawing bitplane to 0

 JSR ResetBuffers       \ Reset the pattern and nametable buffers

 LDA #00000000          \ Set DTW6 = %00000000 so lower case is not enabled
 STA DTW6

 LDA #%11111111         \ Set DTW2 = %11111111 to denote that we are not
 STA DTW2               \ currently printing a word

 LDA #%11111111         \ Set DTW8 = %11111111 to denote that we do not
 STA DTW8               \ capitalise the next character

                        \ Fall through into SetBank0 to page ROM bank 0 into
                        \ memory

