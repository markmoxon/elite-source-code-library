\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 1 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Calculate how many tile patterns we need to send and jump to the
\             most efficient routine for sending them
\
\ ******************************************************************************

.spat1

 ADD_CYCLES_CLC 4       \ Add 4 to the cycle count

 JMP SendNametableNow   \ Jump to SendNametableNow to start sending nametable
                        \ entries to the PPU immediately

.spat2

 JMP spat21             \ Jump down to part 4 to start sending pattern data
                        \ until we run out of cycles

.SendPatternsToPPU

 SUBTRACT_CYCLES 182    \ Subtract 182 from the cycle count

 BMI spat3              \ If the result is negative, jump to spat3 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP spat4              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to spat4
                        \ to start sending tile pattern data to the PPU

.spat3

 ADD_CYCLES 141         \ Add 141 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.spat4

 LDA lastPattern,X      \ Set A to the number of the last pattern number to send
                        \ for this bitplane

 BNE spat5              \ If it is zero (i.e. we have no free tiles), then set
 LDA #255               \ A to 255, so we can use A as an upper limit

.spat5

 STA lastTile           \ Store the result in lastTile, as we want to stop
                        \ sending tiles once we have reached this tile

 LDA ppuNametableAddr+1 \ Set the high byte of the following calculation:
 SEC                    \
 SBC nameBufferHiAddr,X \   (ppuToBuffNameHi 0) = (ppuNametableAddr+1 0)
 STA ppuToBuffNameHi,X  \                          - (nameBufferHiAddr 0)
                        \
                        \ So ppuToBuffNameHi for this bitplane contains a high
                        \ byte that we can add to a PPU nametable address to get
                        \ the corresponding address in the nametable buffer

 LDY pattTileBuffLo,X   \ Set Y to the low byte of the address of the pattern
                        \ buffer for sendingPattTile in bitplane X (i.e. the
                        \ address of the next tile we want to send)
                        \
                        \ We can use this as an index when copying data from
                        \ the pattern buffer, as we know the pattern buffers
                        \ start on page boundaries, so the low byte of the
                        \ address of the start of each buffer is zero

 LDA pattTileBuffHi,X   \ Set the high byte of dataForPPU(1 0) to the high byte
 STA dataForPPU+1       \ of the pattern buffer for this bitplane, as we want
                        \ to copy data from the pattern buffer to the PPU

 LDA sendingPattTile,X  \ Set A to the number of the next tile we want to send
                        \ from the pattern buffer for this bitplane

 STA pattTileCounter    \ Store the number in pattTileCounter, so we can keep
                        \ track of which tile we are sending

 SEC                    \ Set A = A - lastTile
 SBC lastTile           \       = pattTileCounter - lastTile

 BCS spat1              \ If pattTileCounter >= lastTile then we have already
                        \ sent all the tile patterns (right up to the last
                        \ tile), so jump to spat1 to move on to sending the
                        \ nametable entries

 LDX ppuCtrlCopy        \ If ppuCtrlCopy is zero then we are not worried about
 BEQ spat6              \ keeping PPU writes within VBlank, so jump to spat6 to
                        \ skip the following and crack on with sending as much
                        \ pattern data as we can to the PPU

                        \ The above subtraction underflowed, as it cleared the C
                        \ flag, so the result in A is a negative number and we
                        \ should interpret &BF in the following as a signed
                        \ integer, -65

 CMP #&BF               \ If A < &BF
 BCC spat2              \
                        \ i.e. pattTileCounter - lastTile < -65
                        \      lastTile - pattTileCounter > 65
                        \
                        \ Then we have 65 or more patterns to sent to the PPU,
                        \ so jump to part 4 (via spat2) to send them until we
                        \ run out of cycles, without bothering to check for the
                        \ last tile (as we have more tiles to send than we can
                        \ fit into one VBlank)
                        \
                        \ Otherwise we have 64 or fewer tile patterns to send,
                        \ so fall through into part 2 to send them one tile at a
                        \ time, checking each one is the last tile to see if
                        \ it's the last tile

