\ ******************************************************************************
\
\       Name: DrawCmdrImage
\       Type: Subroutine
\   Category: Status
\    Summary: Draw the commander image as a coloured face image in front of a
\             greyscale headshot image, with optional embellishments
\
\ ******************************************************************************

.DrawCmdrImage

                        \ The commander image is made up of two layers and some
                        \ optional embellishments:
                        \
                        \   * A greyscale headshot (i.e. the head and shoulders)
                        \     that's displayed as a background using the
                        \     nametable tiles, whose patterns are extracted into
                        \     the pattern buffers by the GetHeadshot routine
                        \
                        \   * A colourful face that's displayed in the
                        \     foreground as a set of sprites, whose patterns are
                        \     sent to the PPU by the GetCmdrImage routine, from
                        \     pattern 69 onwards
                        \
                        \   * A pair of dark glasses (if we are a fugitive)
                        \
                        \   * Left and right earrings and a medallion, depending
                        \     on how rich we are
                        \
                        \ We start by drawing the background into the nametable
                        \ buffers

 LDX #6                 \ Set X = 6 to use as the number of columns in the image

 LDY #8                 \ Set Y = 8 to use as the number of rows in the image

 STX K                  \ Set K = X, so we can pass the number of columns in the
                        \ image to DrawBackground below

 STY K+1                \ Set K+1 = Y, so we can pass the number of rows in the
                        \ image to DrawBackground below

 LDA firstFreePattern   \ Set pictureTile to the number of the next free pattern
 STA pictureTile        \ in firstFreePattern
                        \
                        \ We use this when setting K+2 below, so the call to
                        \ DrawBackground displays the tiles at pictureTile, and
                        \ it's also used to specify where to load the system
                        \ image data when we call GetCmdrImage from
                        \ SendViewToPPU when showing the Status screen

 CLC                    \ Add 48 to firstFreePattern, as we are going to use 48
 ADC #48                \ patterns for the system image (8 rows of 6 tiles)
 STA firstFreePattern

 LDX pictureTile        \ Set K+2 to the value we stored above, so K+2 is the
 STX K+2                \ number of the first pattern to use for the commander
                        \ image's greyscale headshot

 JSR DrawBackground_b3  \ Draw the background by writing the nametable buffer
                        \ entries for the greyscale part of the commander image
                        \ (this is the image that is extracted into the pattern
                        \ buffers by the GetSystemBack routine)

                        \ Now that the background is drawn, we move on to the
                        \ sprite-based foreground, which contains the face image
                        \
                        \ We draw the face image from sprites with sequential
                        \ patterns, so now we configure the variables to pass
                        \ to the DrawSpriteImage routine

 LDA #5                 \ Set K = 5, to pass as the number of columns in the
 STA K                  \ image to DrawSpriteImage below

 LDA #7                 \ Set K+1 = 7, to pass as the number of rows in the
 STA K+1                \ image to DrawSpriteImage below

 LDA #69                \ Set K+2 = 69, so we draw the face image using
 STA K+2                \ pattern 69 onwards

 LDA #20                \ Set K+3 = 20, so we build the image from sprite 20
 STA K+3                \ onwards

 LDX #4                 \ Set X = 4 so we draw the image four pixels into the
                        \ (XC, YC) character block along the x-axis

 LDY #0                 \ Set Y = 0 so we draw the image at the top of the
                        \ (XC, YC) character block along the y-axis

 JSR DrawSpriteImage_b6 \ Draw the face image from sprites, using pattern 69
                        \ onwards

                        \ Next, we draw a pair of smooth-criminal dark glasses
                        \ in front of the face if we have got a criminal record

 LDA FIST               \ If our legal status in FIST is less than 40, then we
 CMP #40                \ are either clean or an offender, so jump to cmdr1 to
 BCC cmdr1              \ skip the following instruction, as we aren't bad
                        \ enough to wear shades

 JSR DrawGlasses        \ If we get here then we are a fugitive, so draw a pair
                        \ of dark glasses in front of the face

.cmdr1

                        \ We now embellish the commander image, depending on how
                        \ much cash we have
                        \
                        \ Note that the CASH amount is stored as a big-endian
                        \ four-byte number with the most significant byte first,
                        \ i.e. as CASH(0 1 2 3)

 LDA CASH               \ If CASH >= &01000000 (1,677,721.6 CR), jump to cmdr2
 BNE cmdr2

 LDA CASH+1             \ If CASH >= &00990000 (1,002,700.8 CR), jump to cmdr2
 CMP #&99
 BCS cmdr2

 CMP #0                 \ If CASH >= &00010000 (6,553.6 CR), jump to cmdr3
 BNE cmdr3

 LDA CASH+2             \ If CASH >= &00004F00 (2,022.4 CR), jump to cmdr3
 CMP #&4F
 BCS cmdr3

 CMP #&28               \ If CASH < &00002800 (1,024.0 CR), jump to cmdr5
 BCC cmdr5

 BCS cmdr4              \ Jump to cmdr4 (this BCS is effectively a JMP as we
                        \ just passed through a BCC)

.cmdr2

 JSR DrawMedallion      \ If we get here then we have more than 1,002,700.8 CR,
                        \ so call DrawMedallion to draw a medallion on the
                        \ commander image

.cmdr3

 JSR DrawRightEarring   \ If we get here then we have more than 2,022.4 CR, so
                        \ call DrawLeftEarring to draw an earring in the
                        \ commander's right ear (i.e. on the left side of the
                        \ commander image

.cmdr4

 JSR DrawLeftEarring    \ If we get here then we have more than 1,024.0 CR, so
                        \ call DrawRightEarring to draw an earring in the
                        \ commander's left ear (i.e. on the right side of the
                        \ commander image
.cmdr5

 LDX XC                 \ We just drew the image at (XC, YC), so decrement them
 DEX                    \ both so we can pass (XC, YC) to the DrawImageFrame
 STX XC                 \ routine to draw a frame around the image, with the
 LDX YC                 \ top-left corner one block up and left from the image
 DEX                    \ corner
 STX YC

 LDA #7                 \ Set K = 7 to pass to the DrawImageFrame routine as the
 STA K                  \ frame width minus 1, so the frame is eight tiles wide,
                        \ to cover the image which is six tiles wide

 LDA #10                \ Set K+1 = 10 to pass to the DrawImageFrame routine as
 STA K+1                \ the frame height, so the frame is ten tiles high,
                        \ to cover the image which is eight tiles high

 JMP DrawImageFrame_b3  \ Call DrawImageFrame to draw a frame around the
                        \ commander image, returning from the subroutine using a
                        \ tail call

