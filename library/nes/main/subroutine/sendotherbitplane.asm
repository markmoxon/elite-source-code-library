\ ******************************************************************************
\
\       Name: SendOtherBitplane
\       Type: Subroutine
\   Category: PPU
\    Summary: Check whether we should send another bitplane to the PPU
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.SendOtherBitplane

 LDX nmiBitplane        \ Set X to the current NMI bitplane (i.e. the bitplane
                        \ for which we have been sending data to the PPU)

 LDA #%00100000         \ Set the NMI bitplane flags as follows:
 STA bitplaneFlags,X    \
                        \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 set   = we have already sent all the data
                        \   * Bit 6 clear = only send pattern data to the PPU
                        \   * Bit 7 clear = do not send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ So this indicates that we have finished sending data
                        \ to the PPU for this bitplane

 SUBTRACT_CYCLES 227    \ Subtract 227 from the cycle count

 BMI obit1              \ If the result is negative, jump to obit1 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP obit2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to obit2
                        \ to check whether we should send this bitplane to the
                        \ PPU

.obit1

 ADD_CYCLES 176         \ Add 176 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.obit2

 TXA                    \ Flip the NMI bitplane between 0 and 1, to it's the
 EOR #1                 \ opposite bitplane to the one we just sent
 STA nmiBitplane

 CMP hiddenBitplane     \ If the NMI bitplane is now different to the hidden
 BNE obit4              \ bitplane, jump to obit4 to update the cycle count
                        \ and return from the subroutine, as we already sent
                        \ the bitplane that's hidden (we only want to update
                        \ the hidden bitplane, to avoid messing up the screen)

                        \ If we get here then the new NMI bitplane is the same
                        \ as the bitplane that's hidden, so we should send it
                        \ to the PPU (this might happen if the value of
                        \ hiddenBitplane changes while we are still sending
                        \ data to the PPU across multiple calls to the NMI
                        \ handler)

 TAX                    \ Set X to the newly flipped NMI bitplane

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the newly flipped NMI
                        \ bitplane

 AND #%10100000         \ This jumps to obit3 if both of the following are true
 CMP #%10000000         \ for bitplane 1:
 BEQ obit3              \
                        \   * Bit 5 is clear (we have not already sent all the
                        \     data to the PPU for the bitplane)
                        \
                        \   * Bit 7 is set (send data to the PPU for the
                        \     bitplane)
                        \
                        \ If both of these are true then jump to obit3 to update
                        \ the cycle count and return from the subroutine without
                        \ sending any more tile data to the PPU in this VBlank

                        \ If we get here then the new bitplane is not configured
                        \ to be sent to the PPU, so we send it now

 JMP SendTilesToPPU     \ Jump to SendTilesToPPU to set up the variables for
                        \ sending tile data to the PPU, and then send them

.obit3

 ADD_CYCLES_CLC 151     \ Add 151 to the cycle count

 RTS                    \ Return from the subroutine

.obit4

 ADD_CYCLES_CLC 163     \ Add 163 to the cycle count

 RTS                    \ Return from the subroutine

