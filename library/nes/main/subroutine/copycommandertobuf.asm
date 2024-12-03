\ ******************************************************************************
\
\       Name: CopyCommanderToBuf
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy a commander file in the BUF buffer, either from a save slot
\             or from the currently active commander in-game
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number to process:
\
\                         * 0 to 7 = copy the commander from save slot A into
\                                    the buffer at BUF, combining all three
\                                    parts to do so
\
\                         * 8 = load the default commander into BUF
\
\                         * 9 = copy the current commander from in-game, in
\                               which case we copy the commander from NAME to
\                               BUF without having to combine separate parts
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.CopyCommanderToBuf

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CMP #9                 \ If A = 9 then this is the current commander in the
 BEQ ctob7              \ left column, so jump to ctob7 to copy the in-game
                        \ commander to BUF

 CMP #8                 \ If A = 8 then this is the middle column, so jump to
 BEQ ResetSaveBuffer+1  \ ResetSaveBuffer+1 to load the default commander into
                        \ BUF

                        \ If we get here then this is one of the save slots on
                        \ the right of the screen and A is in the range 0 to 7,
                        \ so now we load the contents of the save slot into the
                        \ buffer at BUF
                        \
                        \ Each save slot is split up into three parts, so we now
                        \ need to combine them to get our commander file

 JSR GetSaveAddresses   \ Set the following for save slot A:
                        \
                        \   SC(1 0) = address of the first saved part
                        \
                        \   Q(1 0) = address of the second saved part
                        \
                        \   S(1 0) = address of the third saved part

 LDY #72                \ We work our way through 73 bytes in each saved part,
                        \ so set an index counter in Y

.ctob1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA (Q),Y              \ Set A to the Y-th byte of the second saved part in
                        \ Q(1 0)

IF _NTSC

 EOR #&F0               \ Set SC2+1 = A with the high nibble flipped
 STA SC2+1

 LDA (S),Y              \ Set SC2 to the Y-th byte from the third part in S(1 0)
 EOR #&0F               \ with the low nibble flipped
 STA SC2

ELIF _PAL

 LSR A                  \ Rotate A to the right, in-place
 BCC ctob2
 ORA #%10000000

.ctob2

 LSR A                  \ Rotate A to the right again, in-place
 BCC ctob3
 ORA #%10000000

.ctob3

 STA SC2+1              \ Set SC2+1 to the newly rotated value of the byte from
                        \ the second saved part

 LDA (S),Y              \ Set SC2 to the Y-th byte from the third part in S(1 0)

 LSR A                  \ Rotate A to the right, in-place
 BCC ctob4
 ORA #%10000000

.ctob4

 STA SC2                \ Set SC2 to the newly rotated value of the byte from
                        \ the third saved part

ENDIF

 LDA (SC),Y             \ Set A to the byte from the first part in SC(1 0)

 CMP SC2+1              \ If A = SC2+1 then jump to ctob5 to store A as our
 BEQ ctob5              \ commander file byte

 CMP SC2                \ If A = SC2 then jump to ctob5 to store A as our
 BEQ ctob5              \ commander file byte

 LDA SC2+1              \ Set A = SC2+1

 CMP SC2                \ If A <> SC2 then the copy protection has failed, so
 BNE ctob9              \ jump to ctob9 to reset the save file

                        \ Otherwise A = SC2, so we store A as our commander file
                        \ byte

.ctob5

 STA BUF,Y              \ Store A as the Y-th byte of our commander file in BUF

 STA (SC),Y             \ Store A as the Y-th byte of the first part in SC(1 0)

IF _NTSC

 EOR #&0F               \ Flip the low nibble of A and store it in the third
 STA (S),Y              \ part in S(1 0)

 EOR #&FF               \ Flip the whole of A and store it in the second part in
 STA (Q),Y              \ Q(1 0)

ELIF _PAL

 ASL A                  \ Set the Y-th byte of the third saved part in S(1 0) to
 ADC #0                 \ the commander file byte, rotated left in-place
 STA (S),Y

 ASL A                  \ Set the Y-th byte of the second saved part in Q(1 0)
 ADC #0                 \ the commander file byte, rotated left in-place
 STA (Q),Y

ENDIF

 DEY                    \ Decrement the byte counter in Y

 BPL ctob1              \ Loop back to ctob1 until we have fetched all 73 bytes
                        \ of the commander file from the three separate parts

                        \ If we get here then we have combined all three saved
                        \ parts into one commander file in BUF, so now we need
                        \ to set the galaxy seeds in bytes #65 to #70, as these
                        \ are not saved in the three parts (as they can easily
                        \ be reconstructed from the galaxy number in GCNT, which
                        \ is what we do now)

 LDA BUF+17             \ Set A to byte #9 of the commander file, which contains
                        \ the galaxy number (0 to 7)

 ASL A                  \ Set Y = A * 8
 ASL A                  \
 ASL A                  \ The galaxySeeds table has eight batches of seeds with
 TAY                    \ each one taking up eight bytes (the last two in each
                        \ batch are zeroes), so we can use Y as an index into
                        \ the table to fetch the seed bytes that we need

 LDX #0                 \ We will put the first six galaxy seed bytes from the
                        \ checksum table into our commander file, so set X = 0
                        \ to act as a commander file byte index

.ctob6

 LDA galaxySeeds,Y      \ Set A to the next seed byte from batch Y

 STA BUF+73,X           \ Store the seed byte in byte #65 + X

 INY                    \ Increment the seed byte index

 INX                    \ Increment the commander file byte index

 CPX #6                 \ Loop back until we have copied all six seed bytes
 BNE ctob6

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

.ctob7

                        \ If we get here then A = 9, so this is the current
                        \ commander on the left of the screen, so we load the
                        \ currently active commander from NAME (which is where
                        \ the game stores the commander we are currently
                        \ playing)

 LDA SVC                \ Clear bit 7 of the save counter so we can increment
 AND #%01111111         \ the save counter once again to record the next save
 STA SVC                \ after this one

 LDX #78                \ We now copy the current commander file to the buffer
                        \ in BUF, so set a counter in X to copy all 79 bytes of
                        \ the file

.ctob8

 LDA NAME,X             \ Copy the X-th byte of the current commander in NAME
 STA currentSlot,X      \ to the X-th byte of BUF
 STA BUF,X              \
                        \ This also copies the file to currentSlot, but this
                        \ isn't used anywhere

 DEX                    \ Decrement the byte counter

 BPL ctob8              \ Loop back until we have copied all 79 bytes

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

.ctob9

                        \ If we get here then the three parts of the save file
                        \ have failed the checksums when being combined, so we
                        \ reset the save file and its constituent parts as it
                        \ looks like this file might have been tampered with

 JSR ResetSaveBuffer    \ Reset the commander file in BUF to the default
                        \ commander

 LDA #' '               \ We now fill the commander filename with spaces, so
                        \ set A to the space character

 LDY #6                 \ Set a counter in Y to fill the seven characters in the
                        \ commander filename

.ctob10

 STA BUF,Y              \ Set the Y-th byte of BUF to a space to blank out the
                        \ name (which is seven characters long and at BUF)

 DEY                    \ Decrement the character counter

 BPL ctob10             \ Loop back until we have set the whole name to spaces

 LDA #0                 \ Set the save count in byte #7 of the save file to 0
 STA BUF+7

 PLA                    \ Set A to the save slot number from the stack (leaving
 PHA                    \ the value on the stack)

 JSR SaveLoadCommander  \ Save the commander into the chosen save slot by
                        \ splitting it up and saving it into three parts in
                        \ saveSlotPart1, saveSlotPart2 and saveSlotPart3, so the
                        \ save slot gets reset to the default commander

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

