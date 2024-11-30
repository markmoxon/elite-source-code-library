\ ******************************************************************************
\
\       Name: BOXS2
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw a vertical line for the left or right border box edge
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   A screen bitmap pixel byte to use for the edge
\
\   (Y SC)              The address in screen bitmap memory of the character
\                       block at the top of the edge
\
\   X                   The height of the line in character blocks (so the line
\                       will be 8 * X pixels tall)
\
\ ******************************************************************************

.BOXS2

 STA R2                 \ Store the pixel byte for the edge in R2, so we can
                        \ fetch it in the drawing loop

 STY SC+1               \ Set SC(1 0) = (Y SC), so SC(1 0) points to the address
                        \ in the screen bitmap where we start drawing the line

.BOXL2

 LDY #7                 \ We start by drawing the vertical line in all eight
                        \ pixel rows in the character block, so set a pixel row
                        \ counter in Y

.BOXL3

 LDA R2                 \ Set A to the pixel byte containing set bits in the
                        \ correct positions for the vertical line

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEY                    \ Decrement the pixel row counter

 BPL BOXL3              \ Loop back until we have drawn a vertical line across
                        \ the whole character block

 LDA SC                 \ We have now drawn a whole character block, so we need
 CLC                    \ to move to the character row below, so add 320 (&140)
 ADC #&40               \ to SC(1 0) to move down one pixel line, as there are
 STA SC                 \ 320 bytes in each character row in the screen bitmap
 LDA SC+1
 ADC #1
 STA SC+1

 DEX                    \ Decrement the character row counter

 BNE BOXL2              \ Loop back until we have drawn X character blocks

 RTS                    \ Return from the subroutine

