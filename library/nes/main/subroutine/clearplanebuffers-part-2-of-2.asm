\ ******************************************************************************
\
\       Name: ClearPlaneBuffers (Part 2 of 2)
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the pattern buffer of data that has already been sent to the
\             PPU for the current bitplane
\
\ ******************************************************************************

.pbuf12

 NOP                    \ This looks like code that has been removed
 NOP
 NOP

.pbuf13

 SUBTRACT_CYCLES 187    \ Subtract 187 from the cycle count

 BMI pbuf14             \ If the result is negative, jump to pbuf14 to skip the
                        \ pattern buffer clearing, as we have run out of cycles
                        \ (we will pick up where we left off in the next VBlank)

 JMP pbuf15             \ The result is positive, so we have enough cycles to
                        \ clear the pattern buffer, so jump to pbuf15 to do just
                        \ that

.pbuf14

 ADD_CYCLES 146         \ Add 146 to the cycle count

 JMP pbuf11             \ Jump to pbuf11 to return from the subroutine

.pbuf15

 LDA clearingPattTile,X \ Set A to clearingPattTile for this bitplane, which
                        \ contains the number of the first tile we need
                        \ to clear in the pattern buffer

 LDY sendingPattTile,X  \ Set Y to sendingPattTile for this bitplane, which we
                        \ used in SendPatternsToPPU to keep track of the current
                        \ tile number as we sent them to the PPU pattern table,
                        \ so this contains the number of the last tile that we
                        \ sent to the PPU pattern table for this bitplane
                        \
                        \ So this contains the number of the last tile we need
                        \ to clear in the nametable buffer

 STY clearBlockSize     \ Set clearBlockSize to the number of the last tile we
                        \ need to clear

 CMP clearBlockSize     \ If A >= clearBlockSize, then the first tile we need to
 BCS pbuf10             \ clear is after the last tile we need to clear, which
                        \ means there are no nametable tiles to clear, so jump
                        \ to pbuf10 to return from the subroutine

 NOP                    \ This looks like code that has been removed

 LDY #0                 \ Set clearAddress(1 0) = (pattBufferHiAddr 0) + A * 8
 STY clearAddress+1     \                  = (pattBufferHiAddr 0) + first tile
 ASL A                  \
 ROL clearAddress+1     \ So clearAddress(1 0) contains the address of the first
 ASL A                  \ tile we sent in this bitplane's pattern buffer
 ROL clearAddress+1
 ASL A
 STA clearAddress
 LDA clearAddress+1
 ROL A
 ADC pattBufferHiAddr,X
 STA clearAddress+1

 LDA #0                 \ Set clearBlockSize(1 0) = (0 clearBlockSize) * 8
 ASL clearBlockSize     \                           + (pattBufferHiAddr 0)
 ROL A                  \                  = (pattBufferHiAddr 0) + last tile
 ASL clearBlockSize     \
 ROL A                  \ So clearBlockSize(1 0) points to the address of the
 ASL clearBlockSize     \ last tile we sent in this bitplane's pattern buffer
 ROL A
 ADC pattBufferHiAddr,X
 STA clearBlockSize+1

 LDA clearBlockSize     \ Set clearBlockSize(1 0)
 SEC                    \        = clearBlockSize(1 0) - clearAddress(1 0)
 SBC clearAddress       \
 STA clearBlockSize     \ So clearBlockSize(1 0) contains the number of tiles we
 LDA clearBlockSize+1   \ already sent from this bitplane's pattern buffer
 SBC clearAddress+1
 BCC pbuf16
 STA clearBlockSize+1
 ORA clearBlockSize
 BEQ pbuf17

 JSR ClearMemory        \ Call ClearMemory to zero clearBlockSize(1 0) pattern
                        \ buffer bytes from address clearAddress(1 0) onwards

 LDA clearAddress+1     \ Set (A clearAddress)
 SEC                    \     = clearAddress(1 0) - (pattBufferHiAddr 0)
 SBC pattBufferHiAddr,X

 LSR A                  \ Set A to the bottom byte of (A clearAddress) / 8
 ROR clearAddress       \
 LSR A                  \ This effectively reverses the calculation we did
 ROR clearAddress       \ above, so A contains the number of the next tile
 LSR A                  \ we need to clear, as returned by ClearMemory, divided
 LDA clearAddress       \ by 8
 ROR A                  \
                        \ We only need to take the low byte, as we know the high
                        \ byte will be zero after this many shifts, as that's
                        \ how we built the value of clearAddress(1 0) above

 CMP clearingPattTile,X \ If A >= clearingPattTile then we did manage to clear
 BCC pbuf16             \ some pattern bytes in ClearMemory, so update the
 STA clearingPattTile,X \ value of clearingPattTile with the new first tile
                        \ number so the next call to this routine will pick up
                        \ where we left off

 RTS                    \ Return from the subroutine

.pbuf16

 NOP                    \ This looks like code that has been removed
 NOP
 NOP
 NOP

 RTS                    \ Return from the subroutine

.pbuf17

 ADD_CYCLES_CLC 35      \ Add 35 to the cycle count

 RTS                    \ Return from the subroutine

