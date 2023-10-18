\ ******************************************************************************
\
\       Name: DrawSaveSlotMark
\       Type: Subroutine
\   Category: Save and load
\    Summary: Draw a slot mark (a dash) next to a saved slot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The save slot number (0 to 7)
\
\   CNT                 The offset of the first free sprite in the sprite buffer
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.DrawSaveSlotMark

 STY YSAV2              \ Store Y in YSAV2 so we can retrieve it below

 LDY CNT                \ Set Y to the offset of the first free sprite in the
                        \ sprite buffer

 LDA #109               \ Set the tile pattern number for sprite Y to 109, which
 STA tileSprite0,Y      \ is the dash that we want to use for the slot mark

 LDA XC                 \ Set the x-coordinate for sprite Y to XC * 8
 ASL A                  \
 ASL A                  \ As each tile is eight pixels wide, this sets the pixel
 ASL A                  \ x-coordinate to tile column XC
 ADC #0
 STA xSprite0,Y

 LDA #%00100010         \ Set the attributes for sprite Y as follows:
 STA attrSprite0,Y      \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA YC                 \ Set the y-coordinate for sprite Y to 6 + YC * 8
 ASL A                  \
 ASL A                  \ As each tile is eight pixels tall, this sets the pixel
 ASL A                  \ y-coordinate to the sixth pixel line within tile row
 ADC #6+YPAL            \ YC
 STA ySprite0,Y

 TYA                    \ Set CNT = Y + 4
 CLC                    \
 ADC #4                 \ So CNT points to the next sprite in the sprite buffer
 STA CNT                \ (as each sprite takes up four bytes in the buffer)

 LDY YSAV2              \ Restore the value of Y that we stored in YSAV2 above
                        \ so that Y is preserved

 RTS                    \ Return from the subroutine

