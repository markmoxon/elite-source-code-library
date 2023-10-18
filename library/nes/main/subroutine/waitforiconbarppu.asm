\ ******************************************************************************
\
\       Name: WaitForIconBarPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Wait until the PPU starts drawing the icon bar
\
\ ******************************************************************************

.WaitForIconBarPPU

 LDA setupPPUForIconBar \ Loop back to the start until setupPPUForIconBar is
 BEQ WaitForIconBarPPU  \ non-zero, at which point the SETUP_PPU_FOR_ICON_BAR
                        \ macro and SetupPPUForIconBar routine are checking to
                        \ see whether the icon bar is being drawn by the PPU

.wbar1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA setupPPUForIconBar \ Loop back until setupPPUForIconBar is zero, at which
 BNE wbar1              \ point the icon bar is being drawn by the PPU

 RTS                    \ Return from the subroutine

