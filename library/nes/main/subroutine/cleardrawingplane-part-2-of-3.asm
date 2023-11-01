\ ******************************************************************************
\
\       Name: ClearDrawingPlane (Part 2 of 3)
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the nametable buffers for the newly flipped drawing plane
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.cdra3

 LDY nmiCounter         \ Set Y to the NMI counter, which is incremented every
                        \ VBlank by the NMI handler

 LDA sendingNameTile,X  \ Set SC to sendingNameTile for this bitplane, which
 STA SC                 \ contains the number of the last tile that was sent to
                        \ the PPU nametable by the NMI handler, divided by 8
                        \
                        \ So this contains the number of the last tile we need
                        \ to clear in the nametable buffer, divided by 8

 LDA clearingNameTile,X \ Set A to clearingNameTile for this bitplane, which
                        \ contains the number of the first tile we need to
                        \ clear in the nametable buffer, divided by 8

 CPY nmiCounter         \ If the NMI counter has incremented since we fetched it
 BNE cdra3              \ above, then the tile numbers we just fetched might
                        \ already be out of date (as the NMI handler runs at
                        \ every VBlank, so it may have been run between now and
                        \ the nmiCounter fetch above), so jump back to cdra3
                        \ to fetch them all again

 LDY SC                 \ Set Y to the number of the last tile divided by 8,
                        \ which we fetched above

 CPY maxNameTileToClear \ If Y >= maxNameTileToClear then set Y to the value of
 BCC cdra4              \ maxNameTileToClear, so Y is capped to a maximum value
 LDY maxNameTileToClear \ of maxNameTileToClear

.cdra4

 STY SC                 \ Set SC to the number of the last tile, capped by the
                        \ maximum value in maxNameTileToClear

 CMP SC                 \ If A >= SC then the first tile we need to clear is
 BCS cdra6              \ after the last tile we need to clear, which means
                        \ there are no nametable tiles to clear, so jump to
                        \ to cdra6 to move on to clearing the pattern buffer
                        \ in part 3

 STY clearingNameTile,X \ Set clearingNameTile to the number of the last tile
                        \ to clear, if we don't clear the whole buffer here
                        \ (which will be the case if the buffer is still being
                        \ sent to the PPU), then we can pick it up again from
                        \ the tile after the batch we are about to clear

 LDY #0                 \ Set clearAddress(1 0) = (nameBufferHiAddr 0) + A * 8
 STY clearAddress+1     \                  = (nameBufferHiAddr 0) + first tile
 ASL A                  \
 ROL clearAddress+1     \ So clearAddress(1 0) contains the address in this
 ASL A                  \ bitplane's nametable buffer of the first tile we sent
 ROL clearAddress+1
 ASL A
 STA clearAddress
 LDA clearAddress+1
 ROL A
 ADC nameBufferHiAddr,X
 STA clearAddress+1

 LDA #0                 \ Set SC(1 0) = (0 SC) * 8 + (nameBufferHiAddr 0)
 ASL SC                 \
 ROL A                  \ So SC(1 0) contains the address in this bitplane's
 ASL SC                 \ nametable buffer of the last tile we sent
 ROL A
 ASL SC
 ROL A
 ADC nameBufferHiAddr,X
 STA SC+1

.cdra5

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC                 \ Set clearBlockSize(1 0) = SC(1 0) - clearAddress(1 0)
 SEC                    \
 SBC clearAddress       \ So clearBlockSize(1 0) contains the number of tiles we
 STA clearBlockSize     \ already sent from this bitplane's nametable buffer
 LDA SC+1               \
 SBC clearAddress+1     \ If the subtraction underflows, then there are no tiles
 BCC cdra6              \ to send, so jump to cdra6 to move on to clearing the
 STA clearBlockSize+1   \ pattern buffer in part 3

                        \ By this point, clearBlockSize(1 0) contains the number
                        \ of tiles we sent from this bitplane's nametable
                        \ buffer, so it contains the number of nametable entries
                        \ we need to clear
                        \
                        \ Also, clearAddress(1 0) contains the address of the
                        \ first tile we sent from this bitplane's nametable
                        \ buffer

 ORA clearBlockSize     \ If both the high and low bytes of clearBlockSize(1 0)
 BEQ cdra6              \ are zero, then there are no tiles to clear, so jump to
                        \ cdra6 to clear the pattern buffer

 LDA #HI(790)           \ Set cycleCount = 790, so the call to ClearMemory
 STA cycleCount+1       \ doesn't run out of cycles and quit early (we are not
 LDA #LO(790)           \ in the NMI handler, so we don't need to count cycles,
 STA cycleCount         \ so this just ensures that the cycle-counting checks
                        \ are not triggered)

 JSR ClearMemory        \ Call ClearMemory to zero clearBlockSize(1 0) nametable
                        \ entries from address clearAddress(1 0) onwards

 JMP cdra5              \ The above should clear the whole block, but if the NMI
                        \ handler is called at VBlank while we are doing this,
                        \ then cycleCount may end up ticking down to zero while
                        \ we are still clearing memory, which would abort the
                        \ call to ClearMemory early, so we now loop back to
                        \ cdra5 to pick up where we left off, eventually exiting
                        \ the loop via the BCC cdra6 instruction above (at which
                        \ point we know for sure that we have cleared the whole
                        \ block)

