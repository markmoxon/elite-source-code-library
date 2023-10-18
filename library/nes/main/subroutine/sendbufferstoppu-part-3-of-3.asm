\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 3 of 3)
\       Type: Subroutine
\   Category: PPU
\    Summary: If we need to send tile nametable and pattern data to the PPU for
\             either bitplane, start doing just that
\
\ ******************************************************************************

.sbuf7

                        \ If we get here then we are not currently sending tile
                        \ data to the PPU, so now we check which bitplane is
                        \ configured to be sent, configure the NMI handler to
                        \ send data for that bitplane to the PPU (over multiple
                        \ calls to the NMI handler, if required), and we also
                        \ hide the bitplane we are updating from the screen, so
                        \ we don't corrupt the screen while updating it

 SUBTRACT_CYCLES 298    \ Subtract 298 from the cycle count

 LDA bitplaneFlags      \ Set A to the bitplane flags for bitplane 0

 AND #%10100000         \ This jumps to sbuf8 if any of the following are true
 CMP #%10000000         \ for bitplane 0:
 BNE sbuf8              \
                        \   * Bit 5 is set (we have already sent all the data
                        \     to the PPU for bitplane 0)
                        \
                        \   * Bit 7 is clear (do not send data to the PPU for
                        \     bitplane 0)
                        \
                        \ If any of these are true, we jump to sbuf8 to consider
                        \ sending bitplane 1 instead

                        \ If we get here then we have not already send all the
                        \ data to the PPU for bitplane 0, and bitplane 0 is
                        \ configured to be sent, so we start sending data for
                        \ bitplane 0 to the PPU

 NOP                    \ This looks like code that has been removed
 NOP
 NOP
 NOP
 NOP

 LDX #0                 \ Set X = 0 and jump to sbuf11 to start sending tile
 JMP sbuf11             \ data to the PPU for bitplane 0

.sbuf8

 LDA bitplaneFlags+1    \ Set A to the bitplane flags for bitplane 1

 AND #%10100000         \ This jumps to sbuf10 if both of the following are true
 CMP #%10000000         \ for bitplane 1:
 BEQ sbuf10             \
                        \   * Bit 5 is clear (we have not already sent all the
                        \     data to the PPU for bitplane 1)
                        \
                        \   * Bit 7 is set (send data to the PPU for bitplane 1)
                        \
                        \ If both of these are true then jump to sbuf10 to start
                        \ sending data for bitplane 1 to the PPU

                        \ If we get here then we don't need to send either
                        \ bitplane to the PPU, so we update the cycle count and
                        \ return from the subroutine

 ADD_CYCLES_CLC 223     \ Add 223 to the cycle count

 RTS                    \ Return from the subroutine

.sbuf9

 ADD_CYCLES_CLC 45      \ Add 45 to the cycle count

 JMP SendTilesToPPU     \ Jump to SendTilesToPPU to set up the variables for
                        \ sending tile data to the PPU, and then send them

.sbuf10

 LDX #1                 \ Set X = 1 so we start sending tile data to the PPU
                        \ for bitplane 1

.sbuf11

                        \ If we get here then we are about to start sending tile
                        \ data to the PPU for bitplane X, so we set nmiBitplane
                        \ to X (so the NMI handler sends data to the PPU for
                        \ that bitplane), and we also set hiddenBitplane to X,
                        \ so that the bitplane we are updating is hidden from
                        \ view (and the other bitplane is shown on-screen)
                        \
                        \ So this is the part of the code that swaps animation
                        \ frames when drawing the space view

 STX nmiBitplane        \ Set the NMI bitplane to the value in X, which will
                        \ be 0 or 1 depending on the value of the bitplane flags
                        \ we tested above

 LDA enableBitplanes    \ If enableBitplanes = 0 then bitplanes are not enabled
 BEQ sbuf9              \ (we must be on the Start screen), so jump to sbuf9 to
                        \ update the cycle count and skip the following two
                        \ instructions

 STX hiddenBitplane     \ Set the hidden bitplane to be the same as the NMI
                        \ bitplane, so the rest of the NMI handler update the
                        \ hidden bitplane (we only want to update the hidden
                        \ bitplane, to avoid messing up the screen)

 JSR SetPaletteForView  \ Set the correct background and sprite palettes for
                        \ the current view and (if this is the space view) the
                        \ hidden bitplane

                        \ Fall through into SendTilesToPPU to set up the
                        \ variables for sending tile data to the PPU, and then
                        \ send them

