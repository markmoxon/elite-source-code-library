\ ******************************************************************************
\
\       Name: Elite loader
\       Type: Subroutine
\   Category: Loader
\    Summary: Perform a number of OS calls, check for sideways RAM, load and
\             move the main game data, and load and run the main game code
\
\ ------------------------------------------------------------------------------
\
\ The loader loads and moves the following files. There is no decryption at this
\ stage - that is all done by the main game code.
\
\   * BDATA is loaded into main memory at &1300-&54FF, and is then moved as
\     follows:
\
\       * &1300-&21FF is moved to &7000-&7EFF in screen memory (i.e. shadow RAM)
\         for the dashboard
\
\       * &2200-&54FF is moved to &7F00-&B1FF in main memory, where the main
\         game code will decrypt it
\
\   * BCODE is loaded into main memory at &1300-&7F47 and the game is started by
\     jumping to &2C6C
\
\ The main game code is then responsible for decrypting BDATA (from &8000 to
\ &B1FF) and BCODE (from the end of the scramble routine to &7F47).
\
\ ******************************************************************************

.ENTRY

 LDA #16                \ Call OSBYTE with A = 16 and X = 0 to set the ADC to
 LDX #0                 \ sample no channels from the joystick/Bitstik
 JSR OSBYTE

 LDA #200               \ Call OSBYTE with A = 200, X = 1 and Y = 0 to disable
 LDX #1                 \ the ESCAPE key and disable memory clearing if the
 JSR OSB                \ BREAK key is pressed

 LDA #13                \ Call OSBYTE with A = 13, X = 0 and Y = 0 to disable
 LDX #0                 \ the "output buffer empty" event
 JSR OSB

 LDA #144               \ Call OSBYTE with A = 144, X = 255 and Y = 0 to move
 LDX #255               \ the screen down one line and turn screen interlace on
 LDY #0
 JSR OSBYTE

 LDA #144               \ Repeat the above command, which has the effect of
 LDX #255               \ setting the interlace to the original value, as the
 JSR OSBYTE             \ OSBYTE call above returns the original setting in Y

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering buffer" event
 JSR OSB

 LDA #LO(B%)            \ Set ZP(1 0) to point to the VDU code table at B%
 STA ZP
 LDA #HI(B%)
 STA ZP+1

 LDY #0                 \ We are now going to send the N% VDU bytes in the table
                        \ at B% to OSWRCH to set up the special mode 1 screen
                        \ that forms the basis for the split-screen mode

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 LDA #%00001111         \ Set the Access Control Register at SHEILA+&34, as
 STA VIA+&34            \ follows:
                        \
                        \   * Bit 7 = IRR = 0: Do not IRQ the CPU with this
                        \   * Bit 6 = TST = 0: Must be set to 0
                        \   * Bit 5 = IFJ = 0: &FC00-&FDFF maps to the 1Mhz bus
                        \   * Bit 4 = ITU = 0: CPU can access external co-pro
                        \   * Bit 3 = Y = 1: &C000-&DFFF set to 8K private RAM
                        \   * Bit 2 = X = 1: &3000-&7FFF set to 20K shadow RAM
                        \   * Bit 1 = E = 1: All shadow RAM locations accessible
                        \   * Bit 0 = D = 1: Display shadow RAM as screen memory
                        \
                        \ In short, this switches the screen memory, which is in
                        \ shadow RAM, into the memory map at &3000-&7FFF, so now
                        \ we can poke directly to the screen memory

 JSR PLL1               \ Call PLL1 to draw Saturn

 LDA #%00001001         \ Clear bits 1 and 2 of the the Access Control Register
 STA VIA+&34            \ at SHEILA+&34, which changes the following:
                        \
                        \   * Bit 2 = X = 1: &3000-&7FFF set to main RAM
                        \   * Bit 1 = E = 1: VDU shadow RAM locations accessible
                        \
                        \ In short, this switches the screen memory, which is in
                        \ shadow RAM, out of the memory map, so &3000-&7FFF is
                        \ now mapped to main RAM and we can't update the screen

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDX #1                 \ cursor editing, so the cursor keys return ASCII values
 JSR OSB                \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("L.BDATA FFFF1300")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which
                        \ loads the BDATA file to address &1300-&54FF, appending
                        \ &FFFF to the address to make sure it loads in the main
                        \ BBC Master rather than getting passed across the Tube
                        \ to the second processor, if one is fitted

 LDA #6                 \ Set the RAM copy of the currently selected paged ROM
 STA LATCH              \ to 6, so it matches the paged ROM selection latch at
                        \ SHEILA+&30 that we are about to set

 LDA VIA+&30            \ Switch ROM bank 6 into memory by setting bits 0-3 of
 AND #%11110000         \ the ROM selection latch at SHEILA+&30 to 6
 ORA #6
 STA VIA+&30

 LDA #%10101010         \ Set A and location &8000 to %10101010
 STA &8000

 LSR A                  \ Shift A and location &8000 right
 LSR &8000

 CMP &8000              \ If A matches location &8000 (i.e. both now contain
 BEQ OK                 \ %01010101) then jump to OK, as ROM bank 6 is writable
                        \ and is therefore RAM, which is what we need for
                        \ running the game

 BRK                    \ Otherwise we can't run the game, so terminate the
                        \ loader with the following error message

 EQUB 0                 \ Error number

 EQUB 22, 7             \ Switch to mode 7 and clear the screen

 EQUS "ELITE needs RAM in slot #6"

 EQUB 0                 \ End of error message

.OK

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA+&34 to switch screen memory into &3000-&7FFF

                        \ We now want to copy &F pages of memory (&F00 bytes)
                        \ from &1300-&21FF to &7000-&7EFF in screen memory

 LDX #&F                \ Set a page counter in X to copy &F pages

 LDA #&13               \ Set ZP(1 0) = &1300
 STA ZP+1
 STZ ZP

 STZ P                  \ Set P(1 0) = &7000
 LDA #&70
 STA P+1

 LDY #0                 \ Set Y = 0 to act as a byte counter within each page

.MPL1

 LDA (ZP),Y             \ Copy the Y-th byte of the memory block at ZP(1 0) to
 STA (P),Y              \ the Y-th byte of the memory block at P(1 0)

 DEY                    \ Decrement the byte counter

 BNE MPL1               \ Loop back to copy the next byte until we have copied a
                        \ whole page of 256 bytes

 INC ZP+1               \ Increment the high bytes of both ZP(1 0) and P(1 0)
 INC P+1                \ so we copy the next page in memory

 DEX                    \ Decrement the page counter

 BNE MPL1               \ Loop back to copy the next page until we have done all
                        \ &F of them

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA+&34 to switch main memory back into &3000-&7FFF

                        \ We now want to copy &33 pages of memory (&3300 bytes)
                        \ from &2200-&54FF to &7F00-&B1FF in main memory

 LDX #&33               \ Set a page counter in X to copy &33 pages

.MPL2

 LDA (ZP),Y             \ Copy the Y-th byte of the memory block at ZP(1 0) to
 STA (P),Y              \ the Y-th byte of the memory block at P(1 0)

 DEY                    \ Decrement the byte counter

 BNE MPL2               \ Loop back to copy the next byte until we have copied a
                        \ whole page of 256 bytes

 INC ZP+1               \ Increment the high bytes of both ZP(1 0) and P(1 0)
 INC P+1                \ so we copy the next page in memory

 DEX                    \ Decrement the page counter

 BNE MPL2               \ Loop back to copy the next page until we have done all
                        \ &33 of them

 CLI                    \ Enable interrupts

 LDX #LO(MESS2)         \ Set (Y X) to point to MESS2 ("L.BCODE FFFF1300")
 LDY #HI(MESS2)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS2, which
                        \ loads the BCODE file to address &1300-&7F48, appending
                        \ &FFFF to the address to make sure it loads in the main
                        \ BBC Master rather than getting passed across the Tube
                        \ to the second processor, if one is fitted

 LDX #LO(MESS3)         \ Set (Y X) to point to MESS3 ("DIR E")
 LDY #HI(MESS3)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS3, which
                        \ changes the disc directory to E

 LDA #6                 \ Set the RAM copy of the currently selected paged ROM
 STA LATCH              \ to 6, so it matches the paged ROM selection latch at
                        \ SHEILA+&30 that we are about to set

 LDA VIA+&30            \ Switch ROM bank 6 into memory by setting bits 0-3 of
 AND #%11110000         \ the ROM selection latch at SHEILA+&30 to 6
 ORA #6
 STA VIA+&30

 JMP &2C6C              \ Jump to the start of the main game code at &2C6C,
                        \ which we just loaded in the BCODE file

