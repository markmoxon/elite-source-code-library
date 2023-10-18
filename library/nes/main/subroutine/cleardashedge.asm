\ ******************************************************************************
\
\       Name: ClearDashEdge
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the right edge of the dashboard
\
\ ******************************************************************************

.ClearDashEdge

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #0                 \ Clear the right edge of the box on rows 20 to 27 in
 STA nameBuffer0+20*32  \ nametable buffer 0
 STA nameBuffer0+21*32
 STA nameBuffer0+22*32
 STA nameBuffer0+23*32
 STA nameBuffer0+24*32
 STA nameBuffer0+25*32
 STA nameBuffer0+26*32
 STA nameBuffer0+27*32

 STA nameBuffer1+20*32  \ Clear the right edge of the box on rows 20 to 27 in
 STA nameBuffer1+21*32  \ nametable buffer 1
 STA nameBuffer1+22*32
 STA nameBuffer1+23*32
 STA nameBuffer1+24*32
 STA nameBuffer1+25*32
 STA nameBuffer1+26*32
 STA nameBuffer1+27*32

 RTS                    \ Return from the subroutine

