\ ******************************************************************************
\
\       Name: UpdateIconBar
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Update the icon bar
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.UpdateIconBar

 LDA iconBarType        \ Set A to the current icon bar type

 JSR SetupIconBar       \ Set up the icon bar

 LDA QQ11               \ If bit 6 of the view type is set, then there is no
 AND #%01000000         \ icon bar on the screen, so jump to ubar2 to return
 BNE ubar2              \ from the subroutine as there is no icon bar to update

 JSR SetIconBarRow      \ Set the row on which the icon bar appears, which
                        \ depends on the view type

 LDA #%10000000         \ Set bit 7 of skipBarPatternsPPU, so the NMI handler
 STA skipBarPatternsPPU \ only sends the nametable entries and not the tile
                        \ patterns

 ASL A                  \ Set barPatternCounter = 0, so the NMI handler sends
 STA barPatternCounter  \ icon bar data to the PPU

.ubar1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA barPatternCounter  \ Loop back to keep the PPU configured in this way until
 BPL ubar1              \ barPatternCounter is set to 128
                        \
                        \ This happens when the NMI handler has finished sending
                        \ all the icon bar's nametable entries to the PPU, so
                        \ this loop keeps the PPU configured to use nametable 0
                        \ and pattern table 0 until the icon bar nametable
                        \ entries have been sent

 ASL skipBarPatternsPPU \ Set skipBarPatternsPPU = 0, so the NMI handler goes
                        \ back to sending both nametable entries and tile
                        \ patterns for the icon bar (when barPatternCounter is
                        \ non-zero)

.ubar2

 RTS                    \ Return from the subroutine

