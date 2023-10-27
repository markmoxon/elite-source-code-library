\ ******************************************************************************
\
\       Name: SIGHT
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw the laser crosshairs
\
\ ******************************************************************************

.SIGHT

 LDY VIEW               \ Fetch the laser power for the current view
 LDA LASER,Y

 BEQ HideSightSprites   \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to HideSightSprites to hide the sight
                        \ sprites and return from the subroutine using a tail
                        \ call

 CMP #POW+9             \ If the laser power in A is not equal to a pulse laser,
 BNE sigh1              \ jump to sigh1 to process the other laser types

 JMP sigh4              \ The laser is a pulse laser, so jump to sigh4 to draw
                        \ the sights for a pulse laser

.sigh1

 CMP #POW+128           \ If the laser power in A is not equal to a beam laser,
 BNE sigh2              \ jump to sigh2 to process the other laser types

 JMP sigh5              \ The laser is a beam laser, so jump to sigh4 to draw
                        \ the sights for a beam laser

.sigh2

 CMP #Armlas            \ If the laser power in A is not equal to a military
 BNE sigh3              \ laser, jump to sigh3 to draw the sights for a mining
                        \ laser

                        \ The laser is a military laser, so we draw the military
                        \ laser sights with a sprite for each of the left,
                        \ right, top and bottom sights

 LDA #%10000000         \ Set the attributes for sprite 8 (for the bottom sight)
 STA attrSprite8        \ as follows:
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 set   = flip vertically

 LDA #%01000000         \ Set the attributes for sprite 6 (for the right sight)
 STA attrSprite6        \ as follows:
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%00000000         \ Set the attributes for sprites 5 and 7 (for the left
 STA attrSprite7        \ and top sights respectively) as follows:
 STA attrSprite5        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDY #207               \ Set the pattern number for sprites 5 and 6 to 207,
 STY pattSprite5        \ for the left and right sights respectively
 STY pattSprite6

 INY                    \ Set the pattern number for sprites 7 and 8 to 208,
 STY pattSprite7        \ for the top and bottom sights respectively
 STY pattSprite8

 LDA #118               \ Position the sprites as follows:
 STA xSprite5           \
 LDA #134               \   * Sprite 5 at (118, 83) for the left sight
 STA xSprite6           \   * Sprite 6 at (134, 83) for the right sight
 LDA #126               \   * Sprite 7 at (126, 75) for the top sight
 STA xSprite7           \   * Sprite 8 at (126, 91) for the bottom sight
 STA xSprite8
 LDA #83+YPAL
 STA ySprite5
 STA ySprite6
 LDA #75+YPAL
 STA ySprite7
 LDA #91+YPAL
 STA ySprite8

 RTS                    \ Return from the subroutine

.sigh3

                        \ The laser is a mining laser, so we draw the mining
                        \ laser sights with a sprite for each of the top-left,
                        \ top-right, bottom-left and bottom-right sights

 LDA #%00000011         \ Set the attributes for sprite 5 (for the top-left
 STA attrSprite5        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%01000011         \ Set the attributes for sprite 6 (for the top-right
 STA attrSprite6        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%10000011         \ Set the attributes for sprite 7 (for the bottom-left
 STA attrSprite7        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 set   = flip vertically

 LDA #%11000011         \ Set the attributes for sprite 8 (for the bottom-right
 STA attrSprite8        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 set   = flip vertically

 LDA #209               \ Set the pattern number for all four sprites to 209
 STA pattSprite5
 STA pattSprite6
 STA pattSprite7
 STA pattSprite8

 LDA #118               \ Position the sprites as follows:
 STA xSprite5           \
 STA xSprite7           \   * Sprite 5 at (118, 75) for the top-left sight
 LDA #134               \   * Sprite 6 at (134, 75) for the top-right sight
 STA xSprite6           \   * Sprite 7 at (118, 91) for the bottom-left sight
 STA xSprite8           \   * Sprite 8 at (134, 91) for the bottom-right sight
 LDA #75+YPAL
 STA ySprite5
 STA ySprite6
 LDA #91+YPAL
 STA ySprite7
 STA ySprite8

 RTS                    \ Return from the subroutine

.sigh4

                        \ The laser is a pulse laser, so we draw the pulse laser
                        \ sights with a sprite for each of the left, right, top
                        \ and bottom sights

 LDA #%00000001         \ Set the attributes for all four sprites as follows:
 LDY #&CC               \
 STA attrSprite5        \   * Bits 0-1    = sprite palette 1
 STA attrSprite6        \   * Bit 5 clear = show in front of background
 STA attrSprite7        \   * Bit 6 clear = do not flip horizontally
 STA attrSprite8        \   * Bit 7 clear = do not flip vertically

 STY pattSprite5        \ Set the pattern number for sprites 5 and 6 to 204,
 STY pattSprite6        \ for the left and right sights respectively

 INY                    \ Set the pattern number for sprites 7 and 8 to 205,
 STY pattSprite7        \ for the top and bottom sights respectively
 STY pattSprite8

 LDA #114               \ Position the sprites as follows:
 STA xSprite5           \
 LDA #138               \   * Sprite 5 at (118, 83) for the left sight
 STA xSprite6           \   * Sprite 6 at (134, 83) for the right sight
 LDA #126               \   * Sprite 7 at (126, 75) for the top sight
 STA xSprite7           \   * Sprite 8 at (126, 91) for the bottom sight
 STA xSprite8
 LDA #83+YPAL
 STA ySprite5
 STA ySprite6
 LDA #71+YPAL
 STA ySprite7
 LDA #95+YPAL
 STA ySprite8

 RTS                    \ Return from the subroutine

.sigh5

                        \ The laser is a beam laser, so we draw the beam laser
                        \ sights with a sprite for each of the top-left,
                        \ top-right, bottom-left and bottom-right sights

 LDA #%00000010         \ Set the attributes for sprite 5 (for the top-left
 STA attrSprite5        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%01000010         \ Set the attributes for sprite 6 (for the top-right
 STA attrSprite6        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%10000010         \ Set the attributes for sprite 7 (for the bottom-left
 STA attrSprite7        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 set   = flip vertically

 LDA #%11000010         \ Set the attributes for sprite 8 (for the bottom-right
 STA attrSprite8        \ sight) as follows:
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 set   = flip vertically

 LDA #206               \ Set the pattern number for all four sprites to 206
 STA pattSprite5
 STA pattSprite6
 STA pattSprite7
 STA pattSprite8

 LDA #122               \ Position the sprites as follows:
 STA xSprite5           \
 STA xSprite7           \   * Sprite 5 at (122, 75) for the top-left sight
 LDA #130               \   * Sprite 6 at (130, 75) for the top-right sight
 STA xSprite6           \   * Sprite 7 at (122, 91) for the bottom-left sight
 STA xSprite8           \   * Sprite 8 at (130, 91) for the bottom-right sight
 LDA #75+YPAL
 STA ySprite5
 STA ySprite6
 LDA #91+YPAL
 STA ySprite7
 STA ySprite8

 RTS                    \ Return from the subroutine

