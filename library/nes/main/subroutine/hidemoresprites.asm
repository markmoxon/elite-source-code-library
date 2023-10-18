\ ******************************************************************************
\
\       Name: HideMoreSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide X + 1 sprites from sprite Y / 4 onwards
\
\ ------------------------------------------------------------------------------
\
\ This routine is similar to HideSprites, except it hides X + 1 sprites rather
\ than X sprites.
\
\ Arguments:
\
\   X                   The number of sprites to hide (we hide X + 1)
\
\   Y                   The number of the first sprite to hide * 4
\
\ ******************************************************************************

.HideMoreSprites

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

.hisp1

 STA ySprite0,Y         \ Set the y-coordinate for sprite Y / 4 to 240 to hide
                        \ it (the division by four is because each sprite in the
                        \ sprite buffer has four bytes of data)

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BPL hisp1              \ Loop back until we have hidden X + 1 sprites

 RTS                    \ Return from the subroutine

