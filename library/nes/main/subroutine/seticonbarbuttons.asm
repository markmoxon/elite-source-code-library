\ ******************************************************************************
\
\       Name: SetIconBarButtons
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set the correct list of button numbers for the icon bar
\
\ ******************************************************************************

.SetIconBarButtons

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA iconBarType        \ Set barButtons(1 0) = iconBarButtons
 ASL A                  \                       + iconBarType * 16
 ASL A                  \
 ASL A                  \ So barButtons(1 0) points to list of button numbers in
 ASL A                  \ the iconBarButtons table for this icon bar type
 ADC #LO(iconBarButtons)
 STA barButtons
 LDA #HI(iconBarButtons)
 ADC #0
 STA barButtons+1

 RTS                    \ Return from the subroutine

