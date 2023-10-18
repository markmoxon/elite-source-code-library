\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 1 of 3)
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the icon bar nametable and palette data to the PPU, if it has
\             changed, before moving on to tile data in part 2
\
\ ******************************************************************************

.SendBuffersToPPU

 LDA barPatternCounter  \ If barPatternCounter = 0, then we need to send the
 BEQ SendBarNamesToPPUS \ nametable entries for the icon bar to the PPU, so
                        \ jump to SendBarNamesToPPU via SendBarNamesToPPUS,
                        \ returning from the subroutine using a tail call

 BPL SendBarPattsToPPUS \ If 0 < barPatternCounter < 128, then we need to send
                        \ the pattern data for the icon bar to the PPU, so
                        \ jump to SendBarPattsToPPU via SendBarPattsToPPUS,
                        \ returning from the subroutine using a tail call

                        \ If we get here then barPatternCounter >= 128, so we
                        \ do not need to send any icon bar data to the PPU

                        \ Fall through into part 2 to look at sending tile data
                        \ to the PPU for the rest of the screen

