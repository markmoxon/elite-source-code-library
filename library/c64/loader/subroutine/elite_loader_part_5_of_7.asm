\ ******************************************************************************
\
\       Name: Elite loader (Part 5 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the screen bitmap and copy colour data into screen RAM
\  Deep dive: Colouring the Commodore 64 bitmap screen
\
\ ******************************************************************************

                        \ We start by clearing the screen bitmap from &4000 to
                        \ &5FFF by zeroing this part of memory

 LDA #0                 \ Set the low byte of ZP(1 0) to 0
 STA ZP

 TAY                    \ Set Y = 0 to act as a byte counter

 LDX #&40               \ Set X = &40 to use as the high byte of ZP(1 0), so the
                        \ next instruction initialises ZP(1 0) to &4000

.LOOP2

 STX ZP+1               \ Set the high byte of ZP(1 0) to X

.LOOP1

 STA (ZP),Y             \ Zero the Y-th byte of ZP(1 0)

 INY                    \ Increment the byte counter in Y

 BNE LOOP1              \ Loop back until we have zeroed a whole page at ZP(1 0)

 LDX ZP+1               \ Set X to the high byte of ZP(1 0)

 INX                    \ Increment X to point to the next page in memory

 CPX #&60               \ Loop back to zero the next page in memory until we
 BNE LOOP2              \ have zeroed all the way to &5FFF

                        \ We now reset the two banks of screen RAM from &6000 to
                        \ &63FF and &6400 to &67FF, so we can then populate them
                        \ with colour data for the text view (&6000 to &63FF)
                        \ and the space view (&6400 to &67FF)

 LDA #&10               \ Set A to the colour byte that we want to fill both
                        \ blocks of screen RAM with, which is &10 to set the
                        \ palette to foreground colour 1 (red) and background
                        \ colour 0 (black)

                        \ At this point, X = &60 from above, which we use as the
                        \ high byte of ZP(1 0), and ZP hasn't changed from zero,
                        \ so the next instruction initialises ZP(1 0) to &6000

.LOOP3

 STX ZP+1               \ Set the high byte of ZP(1 0) to X

.LOOP4

 STA (ZP),Y             \ Set the Y-th byte of ZP(1 0) to &10

 INY                    \ Increment the byte counter

 BNE LOOP4              \ Loop back until we have filled a whole page with the
                        \ red/black palette byte

 LDX ZP+1               \ Set X to the high byte of ZP(1 0)

 INX                    \ Increment X to point to the next page in memory

 CPX #&68               \ Loop back to zero the next page in memory until we
 BNE LOOP3              \ have zeroed all the way to &67FF

                        \ Next, we populate screen RAM for the space view (&6400
                        \ to &67FF), starting with the dashboard in the lower
                        \ part of the screen

 LDA #LO(SCBASE+&2400+&2D0)     \ Set ZP(1 0) to the address within the space
 STA ZP                         \ view's screen RAM that corresponds to the
 LDA #HI(SCBASE+&2400+&2D0)     \ dashboard (i.e. offset &2D0 within the screen
 STA ZP+1                       \ RAM at SCBASE + &2400, or &6400)

 LDA #LO(sdump)         \ Set (A ZP2) = sdump
 STA ZP2
 LDA #HI(sdump)

 JSR mvsm               \ Call mvsm to copy 280 bytes of data from sdump to the
                        \ dashboard's screen RAM for the space view, so this
                        \ sets the correct colour data for the dashboard (along
                        \ with the data that we copy into colour RAM in part 6)

\LDX #0                 \ These instructions are commented out in the original
\                       \ source
\.LOOP20
\
\LDA date,X
\STA SCBASE+&7A0,X
\
\DEX
\
\BNE LOOP20

                        \ Now we populate screen RAM for the text view (&6000
                        \ to &63FF) to set the correct colour for the border box
                        \ around the edges of the screen
                        \
                        \ The screen borders are four character blocks wide on
                        \ each side of the screen (so the 256-pixel wide game
                        \ screen gets shown in the middle of the 320-pixel wide
                        \ screen mode)
                        \
                        \ The outside three character blocks show nothing and
                        \ are plain black, which we achieve by setting both the
                        \ foreground and background colours to black for these
                        \ character blocks
                        \
                        \ The innermost of the four character blocks on each
                        \ side is used to draw the border box, with the border
                        \ being right up against the game screen, so for this we
                        \ need a palette of yellow on black, so we can draw the
                        \ border box in yellow

 LDA #0                 \ Set ZP(1 0) = &6000
 STA ZP                 \
 LDA #&60               \ So ZP(1 0) points to screen RAM for the text view
 STA ZP+1

 LDX #25                \ The text view is 25 character rows high, so set a row
                        \ counter in X

.LOOP10

 LDA #&70               \ Set A to the colour byte that we want to apply to the
                        \ border box, which is &70 to set the palette to
                        \ foreground colour 7 (yellow) and background colour 0
                        \ (black)

 LDY #36                \ Set the colour data for column 36 (i.e. the right edge
 STA (ZP),Y             \ of the border box) to the yellow/black palette

 LDY #3                 \ Set the colour data for column 3 (i.e. the left edge
 STA (ZP),Y             \ of the border box) to the yellow/black palette

                        \ Next, we set the palette to black on black for the
                        \ outside three character blocks on the left side of the
                        \ screen, so they don't show anything at all

 DEY                    \ Set Y = 2 to use as a column counter for the three
                        \ character blocks, so we work our way through columns
                        \ 2, 1 and 0

 LDA #&00               \ Set A to the colour byte that we want to apply to the
                        \ outer border area, which is &00 to set the palette to
                        \ foreground colour 0 (black) and background colour 0
                        \ (black)

.frogl

 STA (ZP),Y             \ Set the colour data for column Y to the black/black
                        \ palette

 DEY                    \ Decrement the column counter

 BPL frogl              \ Loop back until we have set all three character blocks
                        \ on the left edge of this character row to the
                        \ black/black palette

                        \ And now we set the palette to black on black for the
                        \ outside three character blocks on the right side of
                        \ the screen, so they also show nothing

 LDY #37                \ Set Y = 2 to use as a column counter for the three
                        \ character blocks, so we work our way through columns
                        \ 37, 38 and 39

 STA (ZP),Y             \ Set the colour data for column 37 to the black/black
                        \ palette

 INY                    \ Set the colour data for column 38 to the black/black
 STA (ZP),Y             \ palette

 INY                    \ Set the colour data for column 39 to the black/black
 STA (ZP),Y             \ palette

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) + 40
 CLC                    \
 ADC #40                \ So ZP(1 0) points to the next character row in screen
 STA ZP                 \ RAM (as there are 40 character blocks on each row)
 BCC P%+4
 INC ZP+1

 DEX                    \ Decrement the row counter in X

 BNE LOOP10             \ Loop back until we have set the colour data for the
                        \ left and right border box edges in the text view

                        \ Now we populate screen RAM for the text view (&6000
                        \ to &63FF) to set the correct colour for the border box
                        \ around the edges of the space view

 LDA #0                 \ Set ZP(1 0) = &6400
 STA ZP                 \
 LDA #&64               \ So ZP(1 0) points to screen RAM for the space view
 STA ZP+1

 LDX #18                \ The space view is 18 character rows high, so set a row
                        \ counter in X

.LOOP11

 LDA #&70               \ Set A to the colour byte that we want to apply to the
                        \ border box, which is &70 to set the palette to
                        \ foreground colour 7 (yellow) and background colour 0
                        \ (black)

 LDY #36                \ Set the colour data for column 36 (i.e. the right edge
 STA (ZP),Y             \ of the border box) to the yellow/black palette

 LDY #3                 \ Set the colour data for column 3 (i.e. the left edge
 STA (ZP),Y             \ of the border box) to the yellow/black palette

                        \ Next, we set the palette to black on black for the
                        \ outside three character blocks on the left side of the
                        \ screen, so they don't show anything at all

 DEY                    \ Set Y = 2 to use as a column counter for the three
                        \ character blocks, so we work our way through columns
                        \ 2, 1 and 0

 LDA #&00               \ Set A to the colour byte that we want to apply to the
                        \ outer border area, which is &00 to set the palette to
                        \ foreground colour 0 (black) and background colour 0
                        \ (black)

.newtl

 STA (ZP),Y             \ Set the colour data for column Y to the black/black
                        \ palette

 DEY                    \ Decrement the column counter

 BPL newtl              \ Loop back until we have set all three character blocks
                        \ on the left edge of this character row to the
                        \ black/black palette

                        \ And now we set the palette to black on black for the
                        \ outside three character blocks on the right side of
                        \ the screen, so they also show nothing

 LDY #37                \ Set Y = 2 to use as a column counter for the three
                        \ character blocks, so we work our way through columns
                        \ 37, 38 and 39

 STA (ZP),Y             \ Set the colour data for column 37 to the black/black
                        \ palette

 INY                    \ Set the colour data for column 38 to the black/black
 STA (ZP),Y             \ palette

 INY                    \ Set the colour data for column 39 to the black/black
 STA (ZP),Y             \ palette

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) + 40
 CLC                    \
 ADC #40                \ So ZP(1 0) points to the next character row in screen
 STA ZP                 \ RAM (as there are 40 character blocks on each row)
 BCC P%+4
 INC ZP+1

 DEX                    \ Decrement the row counter in X

 BNE LOOP11             \ Loop back until we have set the colour data for the
                        \ left and right border box edges in the space view

                        \ Finally, we set the colour data for the bottom row in
                        \ the text view, so the bottom of the border box is also
                        \ shown in yellow

 LDA #&70               \ Set A to the colour byte that we want to apply to the
                        \ border box, which is &70 to set the palette to
                        \ foreground colour 7 (yellow) and background colour 0
                        \ (black)

 LDY #31                \ Set a counter in Y to work through the 31 character
                        \ columns in the text view

.LOOP16

 STA &63C4,Y            \ Set the colour data for column Y + 4 on row 24 to
                        \ yellow on black
                        \
                        \ The address breaks down as follows:
                        \
                        \   &63C4 = &6000 + 24 * 40 + 4
                        \
                        \ So &63C4 + Y is column Y + 4 on row 24 and this loop
                        \ sets the colour for the bottom character row of the
                        \ text view

 DEY                    \ Decrement the column counter

 BPL LOOP16             \ Loop back until we have set the colour for the bottom
                        \ border box in the text view

