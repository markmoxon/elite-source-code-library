\ ******************************************************************************
\
\       Name: SaveLoadCommander
\       Type: Subroutine
\   Category: Save and load
\    Summary: Either save the commander from BUF into a save slot, or load the
\             commander from BUF into the game and start the game
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number to process:
\
\                         * 0 to 7 = save the current commander from BUF into
\                                    save slot A
\
\                         * 9 = load the current commander from BUF into the
\                               game and start the game
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.SaveLoadCommander

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 CMP #9                 \ If A = 9 then this is the current commander in the
 BEQ scom2              \ left column, so jump to scom2 to load the commander
                        \ in BUF into the game

                        \ If we get here then this is one of the save slots on
                        \ the right of the screen and A is in the range 0 to 7,
                        \ so now we save the contents of BUF into the save slot
                        \
                        \ Each save slot is split up into three parts, so we now
                        \ need to split the commander file before saving them

 JSR GetSaveAddresses   \ Set the following for save slot A:
                        \
                        \   SC(1 0) = address of the first saved part
                        \
                        \   Q(1 0) = address of the second saved part
                        \
                        \   S(1 0) = address of the third saved part

 LDA BUF+7              \ Clear bit 7 of the save counter byte in the commander
 AND #%01111111         \ file at BUF so we can increment the save counter once
 STA BUF+7              \ again to record the next save after this one (the save
                        \ counter is in the byte just after the commander name,
                        \ which is seven characters long, so it's at BUF+7)

 LDY #72                \ We work our way through 73 bytes in each saved part,
                        \ so set an index counter in Y

.scom1

 LDA BUF,Y              \ Copy the Y-th byte of the commander file in BUF to the
 STA (SC),Y             \ Y-th byte of the first saved part

IF _NTSC

 EOR #&0F               \ Set the Y-th byte of the third saved part in S(1 0) to
 STA (S),Y              \ the commander file byte with the low nibble flipped

 EOR #&FF               \ Set the Y-th byte of the second saved part in Q(1 0)
 STA (Q),Y              \ to the commander file byte with both nibbles flipped

ELIF _PAL

 ASL A                  \ Set the Y-th byte of the third saved part in S(1 0) to
 ADC #0                 \ the commander file byte, rotated left in-place
 STA (S),Y

 ASL A                  \ Set the Y-th byte of the second saved part in Q(1 0)
 ADC #0                 \ the commander file byte, rotated left in-place
 STA (Q),Y

ENDIF

 DEY                    \ Decrement the byte counter in Y

 BPL scom1              \ Loop back to scom1 until we have split all 73 bytes
                        \ of the commander file into the three separate parts

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

 PHA                    \ This instruction is never run, but it would allow this
                        \ part of the subroutine to be called on its own by
                        \ storing the value of A on the stack so we could
                        \ restore it at the end of the subroutine

.scom2

                        \ If we get here then A = 9, so this is the current
                        \ commander on the left of the screen, so we set the
                        \ currently active in-game commander in NAME to the
                        \ commander in BUF

 LDX #78                \ Set a counter in X to copy all 79 bytes of the file

.scom3

 LDA BUF,X              \ Copy the X-th byte of BUF to the X-th byte of the
 STA currentSlot,X      \ current commander in NAME
 STA NAME,X             \
                        \ This also copies the file to currentSlot, but this
                        \ isn't used anywhere

 DEX                    \ Decrement the byte counter

 BPL scom3              \ Loop back until we have copied all 79 bytes

 JSR SetupAfterLoad_b0  \ Configure the game to use the newly loaded commander
                        \ file

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

