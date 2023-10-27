\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 2 of 3)
\       Type: Subroutine
\   Category: PPU
\    Summary: If we are already sending tile data to the PPU, pick up where we
\             left off, otherwise jump to part 3 to check for new data to send
\
\ ******************************************************************************

 LDX nmiBitplane        \ Set X to the current NMI bitplane (i.e. the bitplane
                        \ for which we are sending data to the PPU in the NMI
                        \ handler)

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the NMI bitplane

 AND #%00010000         \ If bit 4 of A is clear, then we are not currently in
 BEQ sbuf7              \ the process of sending tile data to the PPU for this
                        \ bitplane, so jump to sbuf7 in part 3 to start sending
                        \ tile data

                        \ If we get here then we are already in the process of
                        \ sending tile data to the PPU, split across multiple
                        \ calls to the NMI handler, so before we can consider
                        \ sending data for anything else, we need to finish the
                        \ job that we already started

 SUBTRACT_CYCLES 56     \ Subtract 56 from the cycle count

 TXA                    \ Set Y to the inverse of X, so Y is the opposite
 EOR #1                 \ bitplane to the NMI bitplane
 TAY

 LDA bitplaneFlags,Y    \ Set A to the bitplane flags for the opposite plane
                        \ to the NMI bitplane

 AND #%10100000         \ If bitplanes are enabled then enableBitplanes = 1, so
 ORA enableBitplanes    \ this jumps to sbuf2 if any of the following are true
 CMP #%10000001         \ for the opposite bitplane:
 BNE sbuf2              \
                        \   * Bitplanes are disabled
                        \
                        \   * Bit 5 is set (we have already sent all the data
                        \     to the PPU for the opposite bitplane)
                        \
                        \   * Bit 7 is clear (do not send data to the PPU for
                        \     the opposite bitplane)
                        \
                        \ If any of these are true, we jump to SendPatternsToPPU
                        \ via sbuf2 to continue sending tiles to the PPU for the
                        \ current bitplane

                        \ If we get here then the following are true:
                        \
                        \   * Bitplanes are enabled
                        \
                        \   * We have not sent all the data for the opposite
                        \     bitplane to the PPU
                        \
                        \   * The opposite bitplane is configured to be sent to
                        \     the PPU

 LDA lastPattern,X      \ Set A to the number of the last pattern number to send
                        \ for this bitplane

 BNE sbuf1              \ If it is zero (i.e. we have no free tiles), then set
 LDA #255               \ A to 255, so we can use A as an upper limit

.sbuf1

 CMP sendingPattern,X   \ If A >= sendingPattern, then the number of the last
 BEQ sbuf3              \ pattern to send is bigger than the number of the
 BCS sbuf3              \ pattern which we are currently sending pattern data
                        \ to the PPU for this bitplane, which means there is
                        \ still some pattern data to send before we have
                        \ processed all the patterns, so jump to sbuf3
                        \
                        \ The BEQ appears to be superfluous here as BCS will
                        \ catch an equality

                        \ If we get here then we have finished sending pattern
                        \ data to the PPU, so we now move on to the next stage
                        \ by jumping to SendPatternsToPPU after adjusting the
                        \ cycle count

 SUBTRACT_CYCLES 32     \ Subtract 32 from the cycle count

.sbuf2

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

.sbuf3

                        \ If we get here then the following are true:
                        \
                        \   * Bitplanes are enabled
                        \
                        \   * We have not sent all the data for the opposite
                        \     bitplane to the PPU
                        \
                        \   * The opposite bitplane is configured to be sent to
                        \     the PPU
                        \
                        \   * We are in the process of sending data for the
                        \     current bitplane to the PPU
                        \
                        \   * We still have pattern data to send to the PPU for
                        \     this bitplane

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the NMI bitplane

 ASL A                  \ Shift A left by one place, so bit 7 becomes bit 6 of
                        \ the original flags, and so on

 BPL RTS1               \ If bit 6 of the bitplane flags is clear, then this
                        \ bitplane is only configured to send pattern data and
                        \ not nametable data, and to stop sending the pattern
                        \ data if the other bitplane is ready to be sent
                        \
                        \ This is the case here as we only jump to sbuf3 if
                        \ the other bitplane is configured to send data to the
                        \ PPU, so we stop sending the pattern data for this
                        \ bitplane by returning from the subroutine (as RTS1
                        \ contains an RTS)

 LDY lastNameTile,X     \ Set Y to the number of the last tile we need to send
                        \ for this bitplane, divided by 8

 AND #%00001000         \ If bit 2 of the bitplane flags is set (as A was
 BEQ sbuf4              \ shifted left above), set Y = 128 to override the last
 LDY #128               \ tile number with 128, which means send all tiles (as
                        \ 128 * 8 = 1024 and 1024 is the buffer size)

.sbuf4

 TYA                    \ Set A = Y - sendingNameTile
 SEC                    \       = lastNameTile - sendingNameTile
 SBC sendingNameTile,X  \
                        \ So this is the number of tiles for which we still have
                        \ to send nametable entries, as sendingNameTile is the
                        \ number of the tile for which we are currently sending
                        \ nametable entries to the PPU, divided by 8

 CMP #48                \ If A < 48, then we have fewer than 48 * 8 = 384
 BCC sbuf6              \ nametable entries to send, so jump to sbuf6 to swap
                        \ the hidden and visible bitplanes before sending the
                        \ next batch of tiles

 SUBTRACT_CYCLES 60     \ Subtract 60 from the cycle count

.sbuf5

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

.sbuf6

 LDA ppuCtrlCopy        \ If ppuCtrlCopy is zero then we are not worried about
 BEQ sbuf5              \ keeping PPU writes within VBlank, so jump to sbuf5 to
                        \ skip the following bitplane flip and crack on with
                        \ sending data to the PPU

 SUBTRACT_CYCLES 134    \ Subtract 134 from the cycle count

 LDA enableBitplanes    \ If bitplanes are enabled then enableBitplanes will be
 EOR hiddenBitplane     \ 1, so this flips hiddenBitplane between 0 and 1 when
 STA hiddenBitplane     \ bitplanes are enabled, and does nothing when they
                        \ aren't (so it effectively swaps the hidden and visible
                        \ bitplanes)

 JSR SetPaletteForView  \ Set the correct background and sprite palettes for
                        \ the current view and (if this is the space view) the
                        \ hidden bit plane

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

