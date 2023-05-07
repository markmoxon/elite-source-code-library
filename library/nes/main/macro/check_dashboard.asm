\ ******************************************************************************
\
\       Name: CHECK_DASHBOARD
\       Type: Macro
\   Category: Screen mode
\    Summary: If the PPU has started drawing the dashboard, switch to nametable
\             0 (&2000) and pattern table 0 (&0000)
\
\ ******************************************************************************

MACRO CHECK_DASHBOARD

 LDA DASHBOARD_SWITCH   \ If bit 7 of DASHBOARD_SWITCH and bit 6 of PPU_STATUS
 BPL skip               \ are set, then call SWITCH_TO_TABLE_0 to:
 LDA PPU_STATUS         \
 ASL A                  \   * Zero DASHBOARD_SWITCH to disable this process
 BPL skip               \     until both conditions are met once again
 JSR SWITCH_TO_TABLE_0  \
                        \   * Clear bits 0 and 4 of PPU_CTRL and PPU_CTRL_COPY,
                        \     to set the base nametable address to &2000 (for
                        \     nametable 0) or &2800 (which is a mirror of &2000)
                        \
                        \   * Clear the C flag
 
.skip

ENDMACRO

