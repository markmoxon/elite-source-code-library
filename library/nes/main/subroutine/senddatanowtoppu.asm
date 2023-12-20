\ ******************************************************************************
\
\       Name: SendDataNowToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the specified bitplane buffers to the PPU immediately,
\             without trying to squeeze it into VBlanks
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the bitplane to send
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\ ******************************************************************************

.SendDataNowToPPU

 TXA                    \ Store the bitplane in X on the stack
 PHA

 LDA #HI(16383)         \ Set cycleCount = 16383 so the call to SendBuffersToPPU
 STA cycleCount+1       \ runs for as long as possible without quitting early
 LDA #LO(16383)         \ (we are not in the NMI handler, so we don't need to
 STA cycleCount         \ count cycles, so this just ensures that the
                        \ cycle-counting checks are not triggered where
                        \ possible)

 JSR SendBuffersToPPU   \ Send the nametable and palette buffers to the PPU for
                        \ bitplane X, as configured in the bitplane flags

 PLA                    \ Set X to the bitplane number we stored on the stack
 PHA                    \ above, leaving the value on the stack so we can still
 TAX                    \ restore it at the end of the routine

 LDA bitplaneFlags,X    \ If bit 5 is set in the flags for bitplane X, then we
 AND #%00100000         \ have now sent all the data to the PPU for this
 BNE sdat1              \ bitplane, so jump to sdat1 to return from the
                        \ subroutine

 LDA #HI(4096)          \ Otherwise the large cycle count above wasn't long
 STA cycleCount+1       \ enough to send all the data to the PPU, so set
 LDA #LO(4096)          \ cycleCount to 4096 to have another go
 STA cycleCount

 JSR SendBuffersToPPU   \ Send the nametable and palette buffers to the PPU for
                        \ bitplane X, as configured in the bitplane flags

 PLA                    \ Retrieve the bitplane number from the stack
 TAX

 LDA bitplaneFlags,X    \ If bit 5 is set in the flags for bitplane X, then we
 AND #%00100000         \ have now sent all the data to the PPU for this
 BNE sdat2              \ bitplane, so jump to sdat2 to return from the
                        \ subroutine

                        \ Otherwise we still haven't sent all the data to the
                        \ PPU, so we play the background music and repeat the
                        \ above

 JSR MakeSoundsAtVBlank \ Wait for the next VBlank and make the current sounds
                        \ (music and sound effects)

 JMP SendDataNowToPPU   \ Loop back to keep sending data to the PPU

.sdat1

 PLA                    \ Retrieve the bitplane number from the stack
 TAX

.sdat2

 JMP MakeSoundsAtVBlank \ Wait for the next VBlank and make the current sounds
                        \ (music and sound effects), returning from the
                        \ subroutine using a tail call

