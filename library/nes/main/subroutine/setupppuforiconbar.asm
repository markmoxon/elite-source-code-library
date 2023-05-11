\ ******************************************************************************
\
\       Name: SetupPPUForIconBar
\       Type: Subroutine
\   Category: Screen mode
\    Summary: If the PPU has started drawing the icon bar, configure the PPU to
\             use nametable 0 and pattern table 0 while preserving A
\
\ ******************************************************************************

.SetupPPUForIconBar

 PHA                    \ Store the value of A on the stack so we can restore
                        \ it after the macro

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 PLA                    \ Restore the value of A so it is preserved

 RTS                    \ Return from the subroutine

