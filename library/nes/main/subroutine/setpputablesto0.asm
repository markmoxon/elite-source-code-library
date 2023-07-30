\ ******************************************************************************
\
\       Name: SetPPUTablesTo0
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set nametable 0 and pattern table 0 for drawing the icon bar
\
\ ******************************************************************************

.SetPPUTablesTo0

 LDA #0                 \ Clear bit 7 of setupPPUForIconBar, so this routine
 STA setupPPUForIconBar \ doesn't get called again until the next NMI interrupt
                        \ at the next VBlank (as the SETUP_PPU_FOR_ICON_BAR
                        \ macro and SetupPPUForIconBar routine only update the
                        \ PPU when bit 7 is set)

 LDA ppuCtrlCopy        \ Set A to the current value of PPU_CTRL

 AND #%11101110         \ Clear bits 0 and 4, which will set the base nametable
                        \ address to &2000 (for nametable 0) and the pattern
                        \ table address to &0000 (for pattern table 0)

 STA PPU_CTRL           \ Update PPU_CTRL to set nametable 0 and pattern table 0

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

