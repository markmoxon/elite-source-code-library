\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 3 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Send pattern data to the PPU for one pattern at a time, checking
\             after each one to see if is the last one
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.spat7

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 27     \ Subtract 27 from the cycle count

 JMP spat13             \ Jump down to spat13 to continue sending data to the
                        \ PPU

.spat8

 JMP spat17             \ Jump down to spat17 to move on to sending nametable
                        \ entries to the PPU

.spat9

                        \ This is the entry point for part 3

 LDX patternCounter     \ We will now work our way through patterns, sending
                        \ data for each one, so set a counter in X that starts
                        \ with the number of the next pattern to send to the PPU

.spat10

 SUBTRACT_CYCLES 400    \ Subtract 400 from the cycle count

 BMI spat11             \ If the result is negative, jump to spat11 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP spat12             \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to
                        \ spat12 to send pattern data to the PPU

.spat11

 ADD_CYCLES 359         \ Add 359 to the cycle count

 JMP spat30             \ Jump to part 6 to save progress for use in the next
                        \ VBlank and return from the subroutine

.spat12

                        \ If we get here then we send pattern data to the PPU

 SEND_DATA_TO_PPU 8     \ Send 8 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ spat7              \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to spat7 to point dataForPPU(1 0) at
                        \ the start of this next page, before returning here

.spat13

 LDA addr               \ Set the following:
 CLC                    \
 ADC #16                \   PPU_ADDR = addr(1 0) + 16
 STA addr               \
 LDA addr+1             \   addr(1 0) = addr(1 0) + 16
 ADC #0                 \
 STA addr+1             \ So PPU_ADDR and addr(1 0) both point to the next
 STA PPU_ADDR           \ tile's pattern in the PPU for this bitplane, as each
 LDA addr               \ tile has 16 bytes of pattern data (8 in each bitplane)
 STA PPU_ADDR

 INX                    \ Increment the tile number in X

 CPX lastToSend         \ If we have reached the last pattern, jump to spat19
 BCS spat8              \ (via spat8 and spat17) to move on to sending the
                        \ nametable entries

 SEND_DATA_TO_PPU 8     \ Send 8 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ spat16             \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to spat16 to point dataForPPU(1 0) at
                        \ the start of this next page, before returning here
                        \ with the C flag clear, ready for the next addition

.spat14

 LDA addr               \ Set the following:
 ADC #16                \
 STA addr               \   PPU_ADDR = addr(1 0) + 16
 LDA addr+1             \
 ADC #0                 \   addr(1 0) = addr(1 0) + 16
 STA addr+1             \
 STA PPU_ADDR           \ The addition works because the C flag is clear, either
 LDA addr               \ because we passed through the BCS above, or because we
 STA PPU_ADDR           \ jumped to spat16 and back
                        \
                        \ So PPU_ADDR and addr(1 0) both point to the next
                        \ tile's pattern in the PPU for this bitplane, as each
                        \ tile has 16 bytes of pattern data (8 in each bitplane)

 INX                    \ Increment the tile number in X

 CPX lastToSend         \ If we have reached the last pattern, jump to spat19
 BCS spat18             \ (via spat18) to move on to sending the nametable
                        \ entries

 SEND_DATA_TO_PPU 8     \ Send 8 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ spat20             \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to spat20 to point dataForPPU(1 0) at
                        \ the start of this next page, before returning here
                        \ with the C flag clear, ready for the next addition

.spat15

 LDA addr               \ Set the following:
 ADC #16                \
 STA addr               \   PPU_ADDR = addr(1 0) + 16
 LDA addr+1             \
 ADC #0                 \   addr(1 0) = addr(1 0) + 16
 STA addr+1             \
 STA PPU_ADDR           \ The addition works because the C flag is clear, either
 LDA addr               \ because we passed through the BCS above, or because we
 STA PPU_ADDR           \ jumped to spat20 and back
                        \
                        \ So PPU_ADDR and addr(1 0) both point to the next
                        \ tile's pattern in the PPU for this bitplane, as each
                        \ tile has 16 bytes of pattern data (8 in each bitplane)

 INX                    \ Increment the tile number in X

 CPX lastToSend         \ If we have reached the last pattern, jump to spat19 to
 BCS spat19             \ move on to sending the nametable entries

 JMP spat10             \ Otherwise we still have patterns to send, so jump back
                        \ to spat10 to check the cycle count and potentially
                        \ send the next batch

.spat16

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC                    \ Clear the C flag so the addition works at spat14

 JMP spat14             \ Jump up to spat14 to continue sending data to the PPU

.spat17

 ADD_CYCLES_CLC 224     \ Add 224 to the cycle count

 JMP spat19             \ Jump to spat19 to move on to sending nametable entries
                        \ to the PPU

.spat18

 ADD_CYCLES_CLC 109     \ Add 109 to the cycle count

.spat19

                        \ If we get here then we have sent the last tile's
                        \ pattern data, so we now move on to sending the
                        \ nametable entries to the PPU
                        \
                        \ Before jumping to SendNametableToPPU, we need to store
                        \ the following variables, so they can be picked up by
                        \ the new routine:
                        \
                        \   * (patternBufferHi patternBufferLo)
                        \
                        \   * sendingPattern
                        \
                        \ Incidentally, these are the same variables that we
                        \ save when storing progress for the next VBlank, which
                        \ makes sense

 STX patternCounter     \ Store X in patternCounter to use below

 NOP                    \ This looks like code that has been removed

 LDX nmiBitplane        \ Set (patternBufferHi patternBufferLo) for this
 STY patternBufferLo,X  \ bitplane to dataForPPU(1 0) + Y (which is the address
 LDA dataForPPU+1       \ of the next byte of data to be sent from the pattern
 STA patternBufferHi,X  \ buffer)

 LDA patternCounter     \ Set sendingPattern for this bitplane to the value of
 STA sendingPattern,X   \ X we stored above (which is the number / 8 of the next
                        \ pattern to be sent from the pattern buffer)

 JMP SendNametableToPPU \ Jump to SendNametableToPPU to start sending the
                        \ nametable to the PPU

.spat20

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC                    \ Clear the C flag so the addition works at spat15

 JMP spat15             \ Jump up to spat14 to continue sending data to the PPU

