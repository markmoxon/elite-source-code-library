\ ******************************************************************************
\
\       Name: HideStardust
\       Type: Subroutine
\   Category: Stardust
\    Summary: Hide the stardust sprites
\
\ ******************************************************************************

.HideStardust

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX NOSTM              \ Set X = NOSTM so we hide NOSTM+1 sprites

 LDY #152               \ Set Y so we start hiding from sprite 152 / 4 = 38

                        \ Fall through into HideMoreSprites to hide NOSTM+1
                        \ sprites from sprite 38 onwards (i.e. 38 to 58 in
                        \ normal space when NOSTM is 20, or 38 to 41 in
                        \ witchspace when NOSTM is 3)

