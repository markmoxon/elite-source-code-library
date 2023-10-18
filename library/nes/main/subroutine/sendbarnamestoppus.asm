\ ******************************************************************************
\
\       Name: SendBarNamesToPPUS
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the nametable entries for the icon bar to the PPU (this is a
\             jump so we can call this routine using a branch instruction)
\
\ ******************************************************************************

.SendBarNamesToPPUS

 JMP SendBarNamesToPPU  \ Jump to SendBarNamesToPPU to send the nametable
                        \ entries for the icon bar to the PPU, returning from
                        \ the subroutine using a tail call

