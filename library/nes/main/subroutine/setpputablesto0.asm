\ ******************************************************************************
\
\       Name: SetPPUTablesTo0
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Switch the PPU to nametable 0 (&2000) and pattern table 0 (&0000)
\
\ ******************************************************************************

.SetPPUTablesTo0

 LDA #0                 \ Set setupPPUForIconBar = 0 to stop the icon bar checks
 STA setupPPUForIconBar \ until both bit 7 of setupPPUForIconBar and bit 6 of
                        \ PPU_STATUS are set once again (i.e. until the next
                        \ frame, assuming checks are still enabled)

 LDA ppuCtrlCopy        \ Set A = ppuCtrlCopy with bits 0 and 4 cleared, so it
 AND #%11101110         \ contains the current value of PPU_CTRL, but with the
                        \ nametable (bit 0) and pattern table (bit 4) set to 0

 STA PPU_CTRL           \ Set PPU_CTRL to A to switch the PPU to nametable 0
                        \ (&2000) and pattern table 0 (&0000)

 STA ppuCtrlCopy        \ Update ppuCtrlCopy with the new value of PPU_CTRL

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

