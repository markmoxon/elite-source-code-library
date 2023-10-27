\ ******************************************************************************
\
\       Name: SetLaserSprite
\       Type: Subroutine
\   Category: Equipment
\    Summary: Set up the sprites in the sprite buffer for a specific laser to
\             show on our Cobra Mk III on the Equip Ship screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The pattern number for the first sprite for this type of
\                       laser, minus 0:
\
\                           * 0 (for pattern 140) for the mining laser
\
\                           * 4 (for pattern 144) for the beam laser
\
\                           * 8 (for pattern 148) for the pulse laser
\
\                           * 12 (for pattern 152) for the military laser
\
\                       This routine is used to set up equipment sprites for all
\                       types of equipment, so this should be set to 0 for
\                       setting up non-laser sprites
\
\   X                   The number of sprites to set up for the equipment
\
\   Y                   The offset into the equipSprites table where we can find
\                       the data for the first sprite to set up for this piece
\                       of equipment (i.e. the equipment sprite number * 4)
\
\ ******************************************************************************

.SetLaserSprite

 STA V                  \ Set V to the sprite offset (which is only used for
                        \ laser sprites)

 STX V+1                \ Set V+1 to the number of sprites to set up

.slas1

 LDA equipSprites+3,Y   \ Extract the offset into the sprite buffer of the
 AND #%11111100         \ sprite we need to set up, which is in bits 2 to 7 of
 TAX                    \ byte #3 for this piece of equipment in the
                        \ equipSprites table, and store it in X
                        \
                        \ Because bits 0 and 1 are cleared, the offset is a
                        \ multiple of four, which means we can use X as an
                        \ index into the sprite buffer as each sprite in the
                        \ sprite buffer takes up four bytes
                        \
                        \ In other words, to set up this sprite in the sprite
                        \ buffer, we need to write the sprite's configuration
                        \ into xSprite0 + X, ySprite0 + X, pattSprite0 + X and
                        \ attrSprite0 + X

 LDA equipSprites+3,Y   \ Extract the palette number to use for this sprite,
 AND #%00000011         \ which is in bits 0 to 1 of byte #3 for this piece of
 STA T                  \ equipment in the equipSprites table

 LDA equipSprites,Y     \ Extract the vertical and horizontal flip flags from
 AND #%11000000         \ bits 7 and 6 of byte #0 for this piece of equipment
                        \ in the equipSprites table, into A

 ORA T                  \ Set bits 0 and 1 of A to the palette number that we
                        \ extracted into T above

 STA attrSprite0,X      \ Set the attributes for our sprite as follows:
                        \
                        \   * Bits 0-1 = sprite palette in T
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 = bit 6 from byte #3 in equipSprites
                        \   * Bit 7 = bit 7 from byte #3 in equipSprites
                        \
                        \ So the sprite's attributes are set correctly

 LDA equipSprites,Y     \ Extract the sprite's pattern number from bits 0 to 5
 AND #%00111111         \ of byte #0 for this piece of equipment in the
 CLC                    \ equipSprites table and add 140
 ADC #140

 ADC V                  \ If this is a laser sprite then V will be the offset
                        \ that we add to 140 to get the correct pattern for the
                        \ specific laser type, so we also add this to A (if this
                        \ is not a laser then V will be 0)

 STA pattSprite0,X      \ Set the pattern number for our sprite to the result
                        \ in A

 LDA equipSprites+1,Y   \ Set our sprite's x-coordinate to byte #1 for this
 STA xSprite0,X         \ piece of equipment in the equipSprites table

 LDA equipSprites+2,Y   \ Set our sprite's y-coordinate to byte #2 for this
 STA ySprite0,X         \ piece of equipment in the equipSprites table

 INY                    \ Increment the index in Y to point to the next entry
 INY                    \ in the equipSprites table, in case there are any more
 INY                    \ sprites to set up
 INY

 DEC V+1                \ Decrement the sprite counter in V+1

 BNE slas1              \ Loop back to set up the next sprite until we have set
                        \ up V+1 sprites for this piece of equipment

 RTS                    \ Return from the subroutine

