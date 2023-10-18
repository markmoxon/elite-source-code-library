\ ******************************************************************************
\
\       Name: HideMostSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide all sprites except for sprite 0 and the icon bar pointer
\
\ ******************************************************************************

.HideMostSprites

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #58                \ Set X = 58 so we hide 59 sprites

 LDY #20                \ Set Y so we start hiding from sprite 20 / 4 = 5

 BNE HideMoreSprites    \ Jump to HideMoreSprites to hide 59 sprites from
                        \ sprite 5 onwards (i.e. sprites 5 to 63, which only
                        \ leaves sprite 0 and the icon bar pointer sprites 1 to
                        \ 4)
                        \
                        \ We return from the subroutine using a tail call (this
                        \ BNE is effectively a JMP as Y is never zero)

