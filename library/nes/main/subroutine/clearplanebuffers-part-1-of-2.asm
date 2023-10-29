\ ******************************************************************************
\
\       Name: ClearPlaneBuffers (Part 1 of 2)
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the nametable and pattern buffers of data that has already
\             been sent to the PPU, starting with the nametable buffer
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The bitplane to clear
\
\ ******************************************************************************

.pbuf1

 NOP                    \ This looks like code that has been removed
 NOP

.pbuf2

 SUBTRACT_CYCLES 39     \ Subtract 39 from the cycle count

.pbuf3

 RTS                    \ Return from the subroutine

.pbuf4

 ADD_CYCLES_CLC 126     \ Add 126 to the cycle count

 JMP pbuf13             \ Jump to pbuf13 in part 2 to consider clearing the
                        \ pattern buffer

.ClearPlaneBuffers

 LDA cycleCount+1       \ If the high byte of cycleCount(1 0) is zero, then the
 BEQ pbuf3              \ cycle count is 255 or less, so jump to pbuf3 to skip
                        \ the buffer clearing, as we have run out of cycles (we
                        \ will pick up where we left off in the next VBlank)

 LDA bitplaneFlags,X    \ If both bits 4 and 5 of the current bitplane flags are
 BIT flagsForClearing   \ clear, then this means:
 BEQ pbuf1              \
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \
                        \ So we are not currently sending tile data to the PPU
                        \ for this bitplane, and we have not already sent the
                        \ data, so we do not need to clear this bitplane as we
                        \ only do so after sending its data to the PPU, which
                        \ we are not currently doing

 AND #%00001000         \ If bit 3 of the of the current bitplane flags is
 BEQ pbuf2              \ clear, then this bitplane is configured not to be
                        \ cleared after it has been sent to the PPU, so jump to
                        \ pbuf2 to return from the subroutine without clearing
                        \ the buffers

                        \ If we get here then we are either in the process of
                        \ sending this bitplane's data to the PPU, or we have
                        \ already sent it, and the bitplane is configured to be
                        \ cleared
                        \
                        \ If we have already sent the data to the PPU, then we
                        \ no longer need it, so we need to clear the buffers so
                        \ they are blank and ready to be drawn for the next
                        \ frame
                        \
                        \ If we are still in the process of sending this
                        \ bitplane's data to the PPU, then we can clear the
                        \ buffers up to the point where we have sent the data,
                        \ as we don't need to keep any data that we have sent
                        \
                        \ The following routine clears the buffers from the
                        \ first tile we sent, up to the tile and pattern numbers
                        \ given by sendingNameTile and sendingPattern, which
                        \ will work in both cases, whether or not we have
                        \ finished sending all the data to the PPU

 SUBTRACT_CYCLES 213    \ Subtract 213 from the cycle count

 BMI pbuf5              \ If the result is negative, jump to pbuf5 to skip the
                        \ buffer clearing, as we have run out of cycles (we
                        \ will pick up where we left off in the next VBlank)

 JMP pbuf6              \ The result is positive, so we have enough cycles to
                        \ clear the buffers, so jump to pbuf6 to do just that

.pbuf5

 ADD_CYCLES 153         \ Add 153 to the cycle count

 JMP pbuf3              \ Jump to pbuf3 to skip the buffer clearing and return
                        \ from the subroutine

.pbuf6

 LDA clearingNameTile,X \ Set A to clearingNameTile for this bitplane, which
                        \ contains the number of the first tile we need to
                        \ clear in the nametable buffer, divided by 8

 LDY sendingNameTile,X  \ Set Y to sendingNameTile for this bitplane, which we
                        \ used in SendNametableToPPU to keep track of the
                        \ current tile number as we sent them to the PPU
                        \ nametable, so this contains the number of the last
                        \ tile, divided by 8, that we sent to the PPU nametable
                        \ for this bitplane
                        \
                        \ So this contains the number of the last tile we need
                        \ to clear in the nametable buffer, divided by 8

 CPY maxNameTileToClear \ If Y >= maxNameTileToClear then set Y to the value of
 BCC pbuf7              \ maxNameTileToClear, so Y is capped to a maximum value
 LDY maxNameTileToClear \ of maxNameTileToClear

.pbuf7

 STY clearBlockSize     \ Set clearBlockSize to the number of the last tile we
                        \ need to clear, divided by 8

 CMP clearBlockSize     \ If A >= clearBlockSize, then the first tile we need to
 BCS pbuf4              \ clear is after the last tile we need to clear, which
                        \ means there are no nametable tiles to clear, so jump
                        \ to pbuf4 to move on to clearing the pattern buffer in
                        \ part 2

 LDY #0                 \ Set clearAddress(1 0) = (nameBufferHiAddr 0) + A * 8
 STY clearAddress+1     \                  = (nameBufferHiAddr 0) + first tile
 ASL A                  \
 ROL clearAddress+1     \ So clearAddress(1 0) contains the address of the first
 ASL A                  \ tile we sent in this bitplane's nametable buffer
 ROL clearAddress+1
 ASL A
 STA clearAddress
 LDA clearAddress+1
 ROL A
 ADC nameBufferHiAddr,X
 STA clearAddress+1

 LDA #0                 \ Set clearBlockSize(1 0) = (0 clearBlockSize) * 8
 ASL clearBlockSize     \                           + (nameBufferHiAddr 0)
 ROL A                  \                  = (nameBufferHiAddr 0) + last tile
 ASL clearBlockSize     \
 ROL A                  \ So clearBlockSize(1 0) points to the address of the
 ASL clearBlockSize     \ last tile we sent in this bitplane's nametable buffer
 ROL A
 ADC nameBufferHiAddr,X
 STA clearBlockSize+1

 LDA clearBlockSize     \ Set clearBlockSize(1 0)
 SEC                    \        = clearBlockSize(1 0) - clearAddress(1 0)
 SBC clearAddress       \
 STA clearBlockSize     \ So clearBlockSize(1 0) contains the number of tiles we
 LDA clearBlockSize+1   \ already sent from this bitplane's nametable buffer
 SBC clearAddress+1     \
 BCC pbuf8              \ If the subtraction underflows, then there are no tiles
 STA clearBlockSize+1   \ to send, so jump to pbuf8 to move on to clearing the
                        \ pattern buffer in part 2

                        \ By this point, clearBlockSize(1 0) contains the number
                        \ of tiles we sent from this bitplane's nametable
                        \ buffer, so it contains the number of nametable entries
                        \ we need to clear
                        \
                        \ Also, clearAddress(1 0) contains the address of the
                        \ first tile we sent from this bitplane's nametable
                        \ buffer

 ORA clearBlockSize     \ If both the high and low bytes of clearBlockSize(1 0)
 BEQ pbuf9              \ are zero, then there are no tiles to clear, so jump to
                        \ pbuf9 and on to part 2 to consider clearing the
                        \ pattern buffer

 JSR ClearMemory        \ Call ClearMemory to zero clearBlockSize(1 0) nametable
                        \ entries from address clearAddress(1 0) onwards
                        \
                        \ If we run out of cycles in the current VBlank, then
                        \ this may not clear the whole block, so it updates
                        \ clearBlockSize(1 0) and clearAddress(1 0) as it clears
                        \ so we can pick it up in the next VBlank

 LDA clearAddress+1     \ Set (A clearAddress)
 SEC                    \     = clearAddress(1 0) - (nameBufferHiAddr 0)
 SBC nameBufferHiAddr,X

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

 CMP clearingNameTile,X \ If A >= clearingNameTile then we did manage to clear
 BCC pbuf12             \ some nametable entries in ClearMemory, so update the
 STA clearingNameTile,X \ value of clearingNameTile with the new first tile
                        \ number so the next call to this routine will pick up
                        \ where we left off

 JMP pbuf13             \ Jump to pbuf13 in part 2 to consider clearing the
                        \ pattern buffer

.pbuf8

 NOP                    \ This looks like code that has been removed
 NOP
 NOP
 NOP

.pbuf9

 ADD_CYCLES_CLC 28      \ Add 28 to the cycle count

 JMP pbuf13             \ Jump to pbuf13 in part 2 to consider clearing the
                        \ pattern buffer

.pbuf10

 ADD_CYCLES_CLC 126     \ Add 126 to the cycle count

.pbuf11

 RTS                    \ Return from the subroutine

