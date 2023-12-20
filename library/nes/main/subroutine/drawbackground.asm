\ ******************************************************************************
\
\       Name: DrawBackground
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw the background of a system or commander image into the
\             nametable buffer
\
\ ------------------------------------------------------------------------------
\
\ We draw an image background using patterns with incremental pattern numbers,
\ as the image's patterns have already been sent to the pattern buffers one
\ after the other.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   The number of columns in the image (i.e. the number of
\                       tiles in each row of the image)
\
\   K+1                 The number of tile rows in the image
\
\   K+2                 The pattern number of the start of the image pattern
\                       data in the pattern table
\
\   K+3                 Number of the first free sprite in the sprite buffer,
\                       where we can build the sprites to make up the image
\
\ ******************************************************************************

.DrawBackground

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDA SC                 \ Set SC(1 0) = SC(1 0) + XC
 CLC                    \
 ADC XC                 \ Starting with the low bytes
 STA SC                 \
                        \ So SC(1 0) contains the address in nametable buffer 0
                        \ of the text character at column XC on row YC

 STA SC2                \ Set SC2(1 0) = SC2(1 0) + XC
                        \
                        \ Starting with the low bytes
                        \
                        \ So SC2(1 0) contains the address in nametable buffer 1
                        \ of the text character at column XC on row YC

 BCC back1              \ If the above addition overflowed, then increment the
 INC SC+1               \ high bytes of SC(1 0) and SC2(1 0) accordingly
 INC SC2+1

.back1

 LDX K+1                \ Set X = K+1 to use as a counter for each row in the
                        \ image

.back2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #0                 \ Set Y as a tile index as we work through the tiles in
                        \ the image

 LDA K+2                \ Set A to the pattern number of the first tile in K+2

.back3

 STA (SC2),Y            \ Set the Y-th nametable entry in both nametable buffers
 STA (SC),Y             \ to the pattern number in A

 CLC                    \ Increment A so we fill the background with incremental
 ADC #1                 \ pattern numbers

 INY                    \ Increment the index counter

 CPY K                  \ Loop back until we have drawn K - 1 tiles
 BNE back3

 STA K+2                \ Update K+2 to the pattern number of the next tile

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC                 \
                        \ So SC(1 0) now points at the next row down (as there
                        \ are 32 tiles on each row)

 STA SC2                \ Set SC2(1 0) = SC2(1 0) + 32
                        \
                        \ Starting with the low bytes
                        \
                        \ So SC2(1 0) now points at the next row down (as there
                        \ are 32 tiles on each row)

 BCC back4              \ If the above addition overflowed, increment the high
 INC SC+1               \ high bytes of SC(1 0) and SC2(1 0) accordingly
 INC SC2+1

.back4

 DEX                    \ Decrement the number of rows to draw, as we have just
                        \ moved down a row

 BNE back2              \ Loop back until we have drawn all X rows in the image

 RTS                    \ Return from the subroutine

