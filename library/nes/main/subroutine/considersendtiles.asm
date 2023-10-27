\ ******************************************************************************
\
\       Name: ConsiderSendTiles
\       Type: Subroutine
\   Category: PPU
\    Summary: If there are enough free cycles, move on to the next stage of
\             sending patterns to the PPU
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS1                Contains an RTS
\
\ ******************************************************************************

.ConsiderSendTiles

 LDX nmiBitplane        \ Set X to the current NMI bitplane (i.e. the bitplane
                        \ for which we are sending data to the PPU in the NMI
                        \ handler)

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the NMI bitplane

 AND #%00010000         \ If bit 4 of A is clear, then we are not currently in
 BEQ RTS1               \ the process of sending tile data to the PPU for this
                        \ bitplane, so return from the subroutine (as RTS1
                        \ contains an RTS)

 SUBTRACT_CYCLES 42     \ Subtract 42 from the cycle count

 BMI next1              \ If the result is negative, jump to next1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP next2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to
                        \ SendPatternsToPPU via next2 to move on to the next
                        \ stage of sending patterns to the PPU

.next1

 ADD_CYCLES 65521       \ Add 65521 to the cycle count (i.e. subtract 15)

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.next2

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to move on to the next stage
                        \ of sending patterns to the PPU

.RTS1

 RTS                    \ Return from the subroutine

