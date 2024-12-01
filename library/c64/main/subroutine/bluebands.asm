\ ******************************************************************************
\
\       Name: BLUEBANDS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear a four-character border along one side of the space view
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y X)               The address of the top-left corner of the border strip
\                       to fill
\
\ ******************************************************************************

.BLUEBANDS

 STX SC                 \ Set SC(1 0) = (Y X)
 STY SC+1

 LDX #18                \ The space view is 144 pixels high, which is 18
                        \ character rows of eight pixels each, so set a row
                        \ counter in X

.BLUEL2

 LDY #23                \ The border is 24 pixels wide (four characters of
                        \ eight pixels each), so set a pixel byte counter in Y
                        \ to cover a whole character row of 24 pixels

.BLUEL1

 LDA #%11111111         \ Set A to a pixel byte with every pixel in colour 1
                        \
                        \ Colour 1 is mapped to black, so this blanks the sides
                        \ of the screen, and because it is a non-zero colour, it
                        \ will cover over any sprites in the border that are set
                        \ to appear behind the screen contents
                        \
                        \ The explosion sprite is the only sprite to be
                        \ configured this way
                        \
                        \ As this process is only done when we change views, it
                        \ means changing the screen won't leave any remnants of
                        \ the explosion sprite behind in the screen border area

 STA (SC),Y             \ Store the pixel byte in the Y-th byte of SC(1 0)

 DEY                    \ Decrement the pixel byte counter

 BPL BLUEL1             \ Loop back until we have done a whole character row

                        \ We now need to move down into the character row below,
                        \ and each 40-character row in screen memory takes up
                        \ 40 * 8 = 320 bytes (&140), so that's what we need to
                        \ add to SC(1 0)

 LDA SC                 \ Set SC(1 0) = SC(1 0) + &140
 CLC                    \
 ADC #&40               \ Starting with the low bytes
 STA SC

 LDA SC+1               \ And then adding the high bytes
 ADC #&01
 STA SC+1

 DEX                    \ Decrement the row counter in X

 BNE BLUEL2             \ Loop back until we have filled all 18 rows along the
                        \ edges of the space view

 RTS                    \ Return from the subroutine

