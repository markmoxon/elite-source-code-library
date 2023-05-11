\ ******************************************************************************
\
\       Name: SETUP_PPU_FOR_ICON_BAR
\       Type: Macro
\   Category: Screen mode
\    Summary: If the PPU has started drawing the icon bar, configure the PPU to
\             use nametable 0 and pattern table 0
\
\ ******************************************************************************

MACRO SETUP_PPU_FOR_ICON_BAR

 LDA setupPPUForIconBar \ If bit 7 of setupPPUForIconBar and bit 6 of PPU_STATUS
 BPL skip               \ are set, then call SetPPUTablesTo0 to:
 LDA PPU_STATUS         \
 ASL A                  \   * Zero setupPPUForIconBar to disable this process
 BPL skip               \     until both conditions are met once again
 JSR SetPPUTablesTo0    \
                        \   * Clear bits 0 and 4 of PPU_CTRL and PPU_CTRL_COPY,
                        \     to set the base nametable address to &2000 (for
                        \     nametable 0) or &2800 (which is a mirror of &2000)
                        \
                        \   * Clear the C flag
 
.skip

ENDMACRO

