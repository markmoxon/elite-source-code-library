\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 5 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Send pattern data to the PPU for two patterns at a time, until we
\             run out of cycles (and without checking for the last pattern)
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.spat22

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 27     \ Subtract 27 from the cycle count

 JMP spat27             \ Jump down to spat27 to continue sending data to the
                        \ PPU

.spat23

                        \ This is the entry point for part 5

 LDX patternCounter     \ We will now work our way through patterns, sending
                        \ data for each one, so set a counter in X that starts
                        \ with the number of the next pattern to send to the PPU

.spat24

 SUBTRACT_CYCLES 266    \ Subtract 266 from the cycle count

 BMI spat25             \ If the result is negative, jump to spat25 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP spat26             \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to
                        \ spat26 to send pattern data to the PPU

.spat25

 ADD_CYCLES 225         \ Add 225 to the cycle count

 JMP spat30             \ Jump to part 6 to save progress for use in the next
                        \ VBlank and return from the subroutine

.spat26

                        \ If we get here then we send pattern data to the PPU

 SEND_DATA_TO_PPU 8     \ Send 8 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ spat22             \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to spat22 to point dataForPPU(1 0) at
                        \ the start of this next page, before returning here

.spat27

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

 SEND_DATA_TO_PPU 8     \ Send 8 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ spat29             \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to spat29 to point dataForPPU(1 0) at
                        \ the start of this next page, before returning here
                        \ with the C flag clear, ready for the next addition

.spat28

 LDA addr               \ Set the following:
 ADC #16                \
 STA addr               \   PPU_ADDR = addr(1 0) + 16
 LDA addr+1             \
 ADC #0                 \   addr(1 0) = addr(1 0) + 16
 STA addr+1             \
 STA PPU_ADDR           \ The addition works because the C flag is clear, either
 LDA addr               \ because we passed through the BCS above, or because we
 STA PPU_ADDR           \ jumped to spat29 and back
                        \
                        \ So PPU_ADDR and addr(1 0) both point to the next
                        \ tile's pattern in the PPU for this bitplane, as each
                        \ tile has 16 bytes of pattern data (8 in each bitplane)

 INX                    \ Increment the tile number in X twice, as we just sent
 INX                    \ data for two tiles

 JMP spat24             \ Loop back to spat24 to check the cycle count and
                        \ potentially send the next batch

.spat29

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC                    \ Clear the C flag so the addition works at spat15

 JMP spat28             \ Jump up to spat28 to continue sending data to the PPU

