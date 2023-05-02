\ ******************************************************************************
\
\       Name: SWITCH_TO_TABLE_0
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Switch the PPU to nametable 0 (&2000) and pattern table 0 (&0000)
\
\ ******************************************************************************

.SWITCH_TO_TABLE_0

 LDA #0                 \ Set DASHBOARD_SWITCH = 0 to stop the CHECK_DASHBOARD
 STA DASHBOARD_SWITCH   \ macro from calling this routine until both bit 7 of
                        \ DASHBOARD_SWITCH and bit 6 of PPU_STATUS are set once
                        \ again

 LDA PPU_CTRL_COPY      \ Set A = PPU_CTRL_COPY with bits 0 and 4 cleared, so it
 AND #%11101110         \ contains the current value of PPU_CTRL, but with the
                        \ nametable (bit 0) and pattern table (bit 4) set to 0

 STA PPU_CTRL           \ Set PPU_CTRL to A to switch the PPU to nametable 0
                        \ (&2000) and pattern table 0 (&0000)

 STA PPU_CTRL_COPY      \ Update PPU_CTRL_COPY with the new value of PPU_CTRL

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

