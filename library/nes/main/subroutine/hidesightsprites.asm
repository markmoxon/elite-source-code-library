\ ******************************************************************************
\
\       Name: HideSightSprites
\       Type: Subroutine
\   Category: Flight
\    Summary: Hide the sprites for the laser sights in the space view
\
\ ******************************************************************************

.HideSightSprites

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the sight sprites by
                        \ moving them off-screen

 STA ySprite5           \ Set the y-coordinates for the five laser sight sprites
 STA ySprite6           \ to 240, to move them off-screen
 STA ySprite7
 STA ySprite8
 STA ySprite9

 RTS                    \ Return from the subroutine

