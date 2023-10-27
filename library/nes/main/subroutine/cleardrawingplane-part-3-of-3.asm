\ ******************************************************************************
\
\       Name: ClearDrawingPlane (Part 3 of 3)
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the pattern buffers for the newly flipped drawing plane
\
\ ******************************************************************************

.cdra6

 LDY nmiCounter         \ Set Y to the NMI counter, which is incremented every
                        \ VBlank by the NMI handler

 LDA sendingPattTile,X  \ Set SC to sendingPattTile for this bitplane, which
 STA SC                 \ contains the number of the last pattern that was sent
                        \ to the PPU pattern table by the NMI handler
                        \
                        \ So this contains the number of the last pattern we
                        \ need to clear in the pattern buffer

 LDA clearingPattern,X  \ Set A to clearingPattern for this bitplane, which
                        \ contains the number of the first pattern we need
                        \ to clear in the pattern buffer

 CPY nmiCounter         \ If the NMI counter has incremented since we fetched it
 BNE cdra6              \ above, then the pattern numbers we just fetched might
                        \ already be out of date (as the NMI handler runs at
                        \ every VBlank, so it may have been run between now and
                        \ the nmiCounter fetch above), so jump back to cdra6
                        \ to fetch them all again

 LDY SC                 \ Set Y to the number of the last pattern, which we
                        \ fetched above

 CMP SC                 \ If A >= SC then the first pattern we need to clear is
 BCS cdra8              \ after the last pattern we need to clear, which means
                        \ there are no pattern entries to clear, so jump to
                        \ to cdra8 to return from the subroutine as we are done

 STY clearingPattern,X  \ Set clearingPattern to the number of the last pattern
                        \ to clear, if we don't clear the whole buffer here
                        \ (which will be the case if the buffer is still being
                        \ sent to the PPU), then we can pick it up again from
                        \ the pattern after the batch we are about to clear

 LDY #0                 \ Set clearAddress(1 0) = (pattBufferHiAddr 0) + A * 8
 STY clearAddress+1     \                 = (pattBufferHiAddr 0) + first pattern
 ASL A                  \
 ROL clearAddress+1     \ So clearAddress(1 0) contains the address in this
 ASL A                  \ bitplane's pattern buffer of the first pattern we sent
 ROL clearAddress+1
 ASL A
 STA clearAddress
 LDA clearAddress+1
 ROL A
 ADC pattBufferHiAddr,X
 STA clearAddress+1

 LDA #0                 \ Set SC(1 0) = (0 SC) * 8 + (pattBufferHiAddr 0)
 ASL SC                 \
 ROL A                  \ So SC(1 0) contains the address in this bitplane's
 ASL SC                 \ pattern buffer of the last pattern we sent
 ROL A
 ASL SC
 ROL A
 ADC pattBufferHiAddr,X
 STA SC+1

.cdra7

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC                 \ Set clearBlockSize(1 0) = SC(1 0) - clearAddress(1 0)
 SEC                    \
 SBC clearAddress       \ So clearBlockSize(1 0) contains the number of patterns
 STA clearBlockSize     \ we already sent from this bitplane's pattern buffer
 LDA SC+1               \
 SBC clearAddress+1     \ If the subtraction underflows, then there are no
 BCC cdra6              \ patterns to send, so jump to cdra6 to make sure we
 STA clearBlockSize+1   \ have cleared the whole pattern buffer

                        \ By this point, clearBlockSize(1 0) contains the number
                        \ of patterns we sent from this bitplane's pattern
                        \ buffer, so it contains the number of pattern entries
                        \ we need to clear
                        \
                        \ Also, clearAddress(1 0) contains the address of the
                        \ first pattern we sent from this bitplane's pattern
                        \ buffer

 ORA clearBlockSize     \ If both the high and low bytes of clearBlockSize(1 0)
 BEQ cdra8              \ are zero, then there are no patterns to clear, so jump
                        \ to cdra8 to return from the subroutine, as we are done

 LDA #HI(790)           \ Set cycleCount = 790, so the call to ClearMemory
 STA cycleCount+1       \ doesn't run out of cycles and quit early (we are not
 LDA #LO(790)           \ in the NMI handler, so we don't need to count cycles,
 STA cycleCount         \ so this just ensures that the cycle-counting checks
                        \ are not triggered)

 JSR ClearMemory        \ Call ClearMemory to zero clearBlockSize(1 0) nametable
                        \ entries from address clearAddress(1 0) onwards


 JMP cdra7              \ The above should clear the whole block, but if the NMI
                        \ handler is called at VBlank while we are doing this,
                        \ then cycleCount may end up ticking down to zero while
                        \ we are still clearing memory, which would abort the
                        \ call to ClearMemory early, so we now loop back to
                        \ cdra7 to pick up where we left off, eventually exiting
                        \ the loop via the BCC cdra6 instruction above (at which
                        \ point we know for sure that we have cleared the whole
                        \ block)

.cdra8

 RTS                    \ Return from the subroutine

