\ ******************************************************************************
\
\       Name: SendBarPattsToPPUS
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the pattern data for the icon bar to the PPU (this is a jump
\             so we can call this routine using a branch instruction)
\
\ ******************************************************************************

.SendBarPattsToPPUS

 JMP SendBarPattsToPPU  \ Jump to SendBarPattsToPPU to send the pattern data for
                        \ the icon bar to the PPU, returning from the subroutine
                        \ using a tail call

