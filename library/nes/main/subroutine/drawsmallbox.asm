\ ******************************************************************************
\
\       Name: DrawSmallBox
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw a small box, typically used for popups or outlines
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   The width of the box to draw in tiles
\
\   K+1                 The height of the box to draw in tiles
\
\   K+2                 The text row on which to draw the top-left corner of the
\                       small box
\
\   K+3                 The text column on which to draw the top-left corner of
\                       the small box
\
\ ******************************************************************************

.DrawSmallBox

 LDA K+2                \ Set the text cursor in XC to column K+2, to pass to
 STA XC                 \ GetNameAddress below

 LDA K+3                \ Set the text cursor in YC to row K+3, to pass to
 STA YC                 \ GetNameAddress below

 JSR GetNameAddress     \ Get the addresses in the nametable buffers for the
                        \ tile at text coordinate (XC, YC), as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1
                        \
                        \ So these point to the address in the nametable buffer
                        \ of the top-left corner of the box

 LDA #61                \ Draw a row of K tiles using pattern 61, which contains
 JSR DrawRowOfTiles     \ a thick horizontal line along the bottom of the
                        \ pattern, so this draws the top of the box

 LDX K+1                \ Set X to the number of rows in the box we want to draw
                        \ from K+1, to use as a counter for the height of the
                        \ box

 JMP sbox2              \ Jump into the loop below at sbox2

.sbox1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC                 \ Add 32 to SC(1 0) to move down to the next row in
 CLC                    \ nametable buffer 0, starting with the low byte
 ADC #32
 STA SC

 STA SC2                \ Update the low byte of SC2(1 0) as well to move down
                        \ in nametable buffer 1 too

 BCC sbox2              \ If the addition overflowed, increment the high bytes
 INC SC+1               \ as well
 INC SC2+1

.sbox2

 LDA #1                 \ We draw the left edge of the box using pattern 1,
                        \ which contains a thick vertical line along the right
                        \ edge of the pattern, so set A = 1 to poke into the
                        \ nametable

 LDY #0                 \ Draw the left edge of the box at the address in
 STA (SC),Y             \ SC(1 0) and SC2(1 0), which draws it in both
 STA (SC2),Y            \ nametable buffers

 LDA #2                 \ We draw the right edge of the box using pattern 2,
                        \ which contains a thick vertical line along the left
                        \ edge of the pattern, so set A = 2 to poke into the
                        \ nametable

 LDY K                  \ Draw the left edge of the box at the address in
 STA (SC),Y             \ SC(1 0) and SC2(1 0) + K, which draws it K blocks to
 STA (SC2),Y            \ the right of the left edge in both nametable buffers

 DEX                    \ Decrement the row counter in X

 BNE sbox1              \ Loop back to draw the left and right edges for the
                        \ next row

 LDA #60                \ Draw a row of K tiles using pattern 61, which contains
 JMP DrawRowOfTiles     \ a thick horizontal line along the top of the pattern,
                        \ so this draws the bottom of the box, returning from
                        \ the subroutine using a tail call

