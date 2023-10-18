\ ******************************************************************************
\
\       Name: SendNametableToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the tile nametable to the PPU if there are enough cycles left
\             in the current VBlank
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SendNametableNow    Send the nametable without checking the cycle count
\
\ ******************************************************************************

.snam1

 ADD_CYCLES_CLC 58      \ Add 58 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.snam2

 ADD_CYCLES_CLC 53      \ Add 53 to the cycle count

 JMP SendOtherBitplane  \ Jump to SendOtherBitplane to consider sending the
                        \ other bitplane to the PPU, if required

.SendNametableToPPU

 SUBTRACT_CYCLES 109    \ Subtract 109 from the cycle count

 BMI snam3              \ If the result is negative, jump to snam3 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP SendNametableNow   \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to
                        \ SendNametableNow to start sending nametable data to
                        \ the PPU

.snam3

 ADD_CYCLES 68          \ Add 68 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.SendNametableNow

 LDX nmiBitplane        \ Set X to the current NMI bitplane (i.e. the bitplane
                        \ for which we are sending data to the PPU in the NMI
                        \ handler)

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the NMI bitplane

 ASL A                  \ Shift A left by one place, so bit 7 becomes bit 6 of
                        \ the original flags, and so on

 BPL snam1              \ If bit 6 of the bitplane flags is clear, then this
                        \ bitplane is only configured to send pattern data and
                        \ not nametable data, so jump to snam1 to return from
                        \ the subroutine

 LDY lastNameTile,X     \ Set Y to the number of the last tile we need to send
                        \ for this bitplane, divided by 8

 AND #%00001000         \ If bit 2 of the bitplane flags is set (as A was
 BEQ snam4              \ shifted left above), set Y = 128 to override the last
 LDY #128               \ tile number with 128, which means send all tiles (as
                        \ 128 * 8 = 1024 and 1024 is the buffer size)

.snam4

 STY lastTile           \ Store Y in lastTile, as we want to stop sending
                        \ nametable entries when we reach this tile

 LDA sendingNameTile,X  \ Set A to the number of the next tile we want to send
                        \ from the nametable buffer for this bitplane, divided
                        \ by 8 (we divide by 8 because there are 1024 entries in
                        \ each nametable, which doesn't fit into one byte, so we
                        \ divide by 8 so the maximum counter value is 128)

 STA nameTileCounter    \ Store the number in nameTileCounter, so we can keep
                        \ track of which tile we are sending (so nameTileCounter
                        \ contains the current tile number, divided by 8)

 SEC                    \ Set A = A - lastTile
 SBC lastTile           \       = nameTileCounter - lastTile

 BCS snam2              \ If nameTileCounter >= lastTile then we have already
                        \ sent all the nametable entries (right up to the last
                        \ tile), so jump to snam2 to consider sending the other
                        \ bitplane

 LDY nameTileBuffLo,X   \ Set Y to the low byte of the address of the nametable
                        \ buffer for sendingNameTile in bitplane X (i.e. the
                        \ address of the next tile we want to send)
                        \
                        \ We can use this as an index when copying data from
                        \ the nametable buffer, as we know the nametable buffers
                        \ start on page boundaries, so the low byte of the
                        \ address of the start of each buffer is zero

 LDA nameTileBuffHi,X   \ Set the high byte of dataForPPU(1 0) to the high byte
 STA dataForPPU+1       \ of the nametable buffer for this bitplane, as we want
                        \ to copy data from the nametable buffer to the PPU

 CLC                    \ Set the high byte of the following calculation:
 ADC ppuToBuffNameHi,X  \
                        \   (A 0) = (nameTileBuffHi 0) + (ppuToBuffNameHi 0)
                        \
                        \ (ppuToBuffNameHi 0) for this bitplane contains a high
                        \ byte that we can add to a nametable buffer address to
                        \ get the corresponding address in the PPU nametable, so
                        \ this sets (A 0) to the high byte of the correct PPU
                        \ nametable address for this tile
                        \
                        \ We already set Y as the low byte above, so we now have
                        \ the full PPU address in (A Y)

 STA PPU_ADDR           \ Set PPU_ADDR = (A Y)
 STY PPU_ADDR           \
                        \ So PPU_ADDR points to the address in the PPU to which
                        \ we send the nametable data

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0, so that
 STA dataForPPU         \ dataForPPU(1 0) points to the start of the nametable
                        \ buffer, and dataForPPU(1 0) + Y therefore points to
                        \ the nametable entry for tile sendingNameTile

.snam5

 SUBTRACT_CYCLES 393    \ Subtract 393 from the cycle count

 BMI snam6              \ If the result is negative, jump to snam6 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

                        \ If we get here then the result is positive, so the C
                        \ flag will be set as the subtraction didn't underflow

 JMP snam7              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to snam7
                        \ to do just that

.snam6

 ADD_CYCLES 349         \ Add 349 to the cycle count

 JMP snam10             \ Jump to snam10 to save progress for use in the next
                        \ VBlank and return from the subroutine

.snam7

 SEND_DATA_TO_PPU 32    \ Send 32 bytes from dataForPPU to the PPU, starting at
                        \ index Y and updating Y to point to the byte after the
                        \ block that is sent

 BEQ snam9              \ If Y = 0 then the next byte is in the next page in
                        \ memory, so jump to snam9 to point dataForPPU(1 0) at
                        \ the start of this next page, before looping back to
                        \ snam5 to potentially send the next batch

                        \ We got here by jumping to snam7 from above, which we
                        \ did with the C flag set, so the ADC #3 below actually
                        \ adds 4

 LDA nameTileCounter    \ Add 4 to nameTileCounter, as we just sent 4 * 8 = 32
 ADC #3                 \ nametable entries (and nameTileCounter counts the tile
 STA nameTileCounter    \ number, divided by 8)

 CMP lastTile           \ If nameTileCounter >= lastTile then we have reached
 BCS snam8              \ the last tile, so jump to snam8 to update the
                        \ variables and jump to SendOtherBitplane to consider
                        \ sending the other bitplane

 JMP snam5              \ Otherwise we still have nametable entries to send, so
                        \ loop back to snam5 to check the cycles and send the
                        \ next batch

.snam8

                        \ If we get here then we have sent the last nametable
                        \ entry, so we now move on to considering whether to
                        \ send the other bitplane to the PPU, if required
                        \
                        \ Before jumping to SendOtherBitplane, we need to store
                        \ the following variables, so they can be picked up by
                        \ the new routine:
                        \
                        \   * (nameTileBuffHi nameTileBuffLo)
                        \
                        \   * sendingNameTile
                        \
                        \ Incidentally, these are the same variables that we
                        \ save when storing progress for the next VBlank, which
                        \ makes sense

 STA sendingNameTile,X  \ Set sendingNameTile for this bitplane to the value of
                        \ nameTileCounter, which we stored in A before jumping
                        \ here

 STY nameTileBuffLo,X   \ Set (nameTileBuffHi nameTileBuffLo) for this bitplane
 LDA dataForPPU+1       \ to dataForPPU(1 0) + Y (which is the address of the
 STA nameTileBuffHi,X   \ next byte of data to be sent from the nametable
                        \ buffer)

 JMP SendOtherBitplane  \ Jump to SendOtherBitplane to consider sending the
                        \ other bitplane to the PPU, if required

.snam9

 INC dataForPPU+1       \ Increment the high byte of dataForPPU(1 0) to point to
                        \ the start of the next page in memory

 SUBTRACT_CYCLES 26     \ Subtract 26 from the cycle count

 LDA nameTileCounter    \ Add 4 to nameTileCounter, as we just sent 4 * 8 = 32
 CLC                    \ nametable entries (and nameTileCounter counts the tile
 ADC #4                 \ number, divided by 8)
 STA nameTileCounter

 CMP lastTile           \ If nameTileCounter >= lastTile then we have reached
 BCS snam8              \ the last tile, so jump to snam8 to update the
                        \ variables and jump to SendOtherBitplane to consider
                        \ sending the other bitplane

 JMP snam5              \ Otherwise we still have nametable entries to send, so
                        \ loop back to snam5 to check the cycles and send the
                        \ next batch

.snam10

                        \ We now store the following variables, so they can be
                        \ picked up when we return in the next VBlank:
                        \
                        \   * (nameTileBuffHi nameTileBuffLo)
                        \
                        \   * sendingNameTile

 LDA nameTileCounter    \ Set sendingNameTile for this bitplane to the number
 STA sendingNameTile,X  \ of the tile to send next, in nameTileCounter

 STY nameTileBuffLo,X   \ Set (nameTileBuffHi nameTileBuffLo) for this bitplane
 LDA dataForPPU+1       \ to dataForPPU(1 0) + Y (which is the address of the
 STA nameTileBuffHi,X   \ next byte of data to be sent from the nametable
                        \ buffer)

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

