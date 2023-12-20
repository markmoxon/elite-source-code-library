\ ******************************************************************************
\
\       Name: HighlightLaserView
\       Type: Subroutine
\   Category: Equipment
\    Summary: Highlight the laser view name in the popup menu
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the laser view:
\
\                         * 0 = front
\                         * 1 = rear
\                         * 2 = left
\                         * 3 = right
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.HighlightLaserView

 LDA #2                 \ Set the font style to print in the highlight font
 STA fontStyle

 JSR PrintLaserView     \ Print the name of the laser view specified in Y at the
                        \ correct on-screen position for the popup menu

 LDA #1                 \ Set the font style to print in the normal font
 STA fontStyle

 TYA                    \ Store Y on the stack so we can retrieve it at the end
 PHA                    \ of the subroutine

 JSR DrawScreenInNMI    \ Configure the NMI handler to draw the screen, so the
                        \ screen gets updated

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 PLA                    \ Retrieve Y from the stack so it is unchanged by the
 TAY                    \ subroutine call

 RTS                    \ Return from the subroutine

