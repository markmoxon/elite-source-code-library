\ ******************************************************************************
\
\       Name: TTX66K
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the whole screen or just the space view (as appropriate),
\             draw a border box, and if required, show the dashboard
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen (the space view) and draw a border box along
\ the top and sides.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BOX                 Just draw the border box along the top and sides
\
\ ******************************************************************************

.TTX66K

                        \ We start by resetting screen RAM for the text view,
                        \ which lives at &6000 and has one byte that defines the
                        \ palette for each character block (as we want to set
                        \ the palette to white pixels on a black background)

 LDA #&04               \ Set SC(1 0) = &6004
 STA SC                 \
 LDA #&60               \ So this skips the four character border on the left
 STA SC+1               \ of the screen, so SC(1 0) points to the top-left
                        \ character of the text view in screen RAM

 LDX #24                \ The text view has 24 character rows, so set a row
                        \ counter in X

.BOL3

 LDA #&10               \ Set A to a colour data byte that sets colour 1 (white)
                        \ for the foreground and colour 0 (black) for the
                        \ background

 LDY #31                \ The game screen is 32 characters wide, so set a column
                        \ counter in Y

.BOL4

 STA (SC),Y             \ Set the Y-th colour data byte at SC(1 0) to A, to set
                        \ white pixels on a black background for the text view

 DEY                    \ Decrement the column counter

 BPL BOL4               \ Loop back until we have set colour bytes for the whole
                        \ row

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 40
 CLC                    \
 ADC #40                \ So this moves SC(1 0) to the next row of colour data,
 STA SC                 \ as there are 40 characters on each row of the screen
 BCC P%+4               \ (with Elite only taking up the middle 32 characters)
 INC SC+1

 DEX                    \ Decrement the row counter

 BNE BOL3               \ Loop back until we have set colour bytes for all 24
                        \ rows, by which time we will have reset the colour
                        \ data for the whole text view

                        \ Next, we zero the space view portion of the screen
                        \ bitmap to clear the top part of the screen of any
                        \ graphics or border boxes

 LDX #HI(SCBASE)        \ Set X to the page number for the start of the screen
                        \ bitmap in memory, which is at SCBASE, so we can use
                        \ this as a page counter while resetting the screen
                        \ bitmap

.BOL1

 JSR ZES1k              \ Call ZES1k to zero-fill the page in X, which will
                        \ clear one page of the screen bitmap by setting all
                        \ pixels to the background colour

 INX                    \ Increment the page counter in X

 CPX #HI(DLOC%)         \ Loop back to keep clearing pages until we reach DLOC%,
 BNE BOL1               \ which is the address of the start of the dashboard in
                        \ the screen bitmap, so we loop back until we have
                        \ cleared up to the start of the page that contains the
                        \ start of the dashboard (which is most of the space
                        \ view, but not the very last bit

                        \ By this point X = HI(DLOC%), which we use in a couple
                        \ of places below

 LDY #LO(DLOC%)-1       \ Set Y to the low byte of the address of the byte just
                        \ before the first dashboard byte

 JSR ZES2k              \ Call ZES2k to zero-fill from address (X SC) + Y to
                        \ (X SC) + 1
                        \
                        \ X is HI(DLOC%), so this zero-fills the page at DLOC%
                        \ from offset Y down to offset 1
                        \
                        \ So this resets the rest of the space view right up
                        \ to the start of the dashboard, though it doesn't do
                        \ the byte at offset 0

 STA (SC),Y             \ The call to ZES2k returns with both A = 0 and Y = 0,
                        \ and SC(1 0) is set to the base address of the block we
                        \ have just zeroed, so to zero the byte at offset 0, we
                        \ just need to set SC(1 0) to 0

 LDA #1                 \ Move the text cursor to column 1
 STA XC

 STA YC                 \ Move the text cursor to row 1

 LDA QQ11               \ If QQ11 = 0 then this is the space view, so jump to
 BEQ wantSTEP           \ wantdials via wantSTEP to display the dashboard in
                        \ the lower portion of the screen

 CMP #13                \ If QQ11 = 13 then this is the title screen, so skip
 BNE P%+5               \ the following instruction if this is not the title
                        \ screen

.wantSTEP

 JMP wantdials          \ If we get here then QQ11 = 0 or 13, which is the space
                        \ view or title screen, so jump to wantdials to display
                        \ the dashboard

                        \ If we get here then this is not the space view or
                        \ title screen, so we do not display the dashboard

 LDA #&81               \ Set abraxas = &81, so the colour of the lower part of
 STA abraxas            \ the screen is determined by screen RAM at &6000
                        \ (i.e. for when the text view is being shown)

 LDA #%11000000         \ Clear bit 4 of caravanserai so that the lower part of
 STA caravanserai       \ the screen (the dashboard) is shown in standard bitmap
                        \ mode

                        \ We set X = HI(DLOC%) above, so it points at the page
                        \ that contains the start of the dashboard and we can
                        \ use this to clear the rest of the screen bitmap, as
                        \ we stopped when we reached the dashboard portion of
                        \ the screen (and we aren't showing the dashboard in
                        \ this view)

.BOL2

 JSR ZES1k              \ Call ZES1k to zero-fill the page in X, which will
                        \ clear part of a character row

 INX                    \ Increment the page in X

 CPX #HI(SCBASE)+&20    \ Loop back until we have cleared all &20 pages of the
 BNE BOL2               \ screen bitmap (i.e. from &4000 to &5FFF)

 LDX #0                 \ Set the compass colour in COMC to the background
 STX COMC               \ colour, so no compass dot gets drawn

 STX DFLAG              \ Set DFLAG to 0 to indicate that there is no dashboard
                        \ being shown on-screen

 INX                    \ Move the text cursor to column 1 (though we already
 STX XC                 \ did this, so this isn't strictly necessary)

 STX YC                 \ Move the text cursor to row 1 (though again, we
                        \ already did this)

 JSR BLUEBAND           \ Clear the borders along the edges of the space view,
                        \ to hide any sprites that might be lurking there

 JSR zonkscanners       \ Hide all ships on the scanner

 JSR NOSPRITES          \ Call NOSPRITES to disable all sprites and remove them
                        \ from the screen

                        \ We now set the colour of the top row of the screen to
                        \ yellow on black, for the border box

 LDY #31                \ The border box is 32 characters wide, so set a column
                        \ counter in Y

 LDA #&70               \ Set A to a colour data byte that sets colour 7
                        \ (yellow) for the foreground and colour 0 (black) for
                        \ the background, so the border box gets drawn in yellow

.BOL5

 STA &6004,Y            \ Set the colour data for the Y-th character of the top
                        \ character row to A, skipping the first four characters
                        \ that form the left border

 DEY                    \ Decrement the column counter in Y

 BPL BOL5               \ Loop back until the whole top character row is set to
                        \ a palette of yellow on black

 LDX QQ11               \ If QQ11 is one of the following:
 CPX #2                 \
 BEQ BOX                \   * 2 (Buy Cargo screen)
 CPX #64                \
 BEQ BOX                \   * 64 (Long-range Chart)
 CPX #128               \
 BEQ BOX                \   * 128 (Short-range Chart)
                        \
                        \ then jump to BOX to skip setting the third row to
                        \ yellow on black (as otherwise this will affect the
                        \ colours just below the line beneath the title text)

                        \ We now set the colour of the third row of the screen
                        \ to yellow on black, for the line beneath the title
                        \ text

 LDY #31                \ The title box is 32 characters wide, so set a column
                        \ counter in Y

.BOL6

 STA &6054,Y            \ Set the colour data for the Y-th character of the
                        \ third character row to A, skipping the first four
                        \ characters that form the left border
                        \
                        \ The address breaks down as follows:
                        \
                        \   &6054 = &6000 + 2 * 40 + 4
                        \
                        \ as each row on-screen contains 40 characters, and we
                        \ want to skip the first two rows, and indent to skip
                        \ the left screen border

 DEY                    \ Decrement the column counter in Y

 BPL BOL6               \ Loop back until the whole of the third character row
                        \ is set to a palette of yellow on black

.BOX

 LDX #199               \ Draw a horizontal line across the screen at pixel
 JSR BOXS               \ y-coordinate 199, to draw the bottom edge of the
                        \ border box

 LDA #&FF               \ This draws an 8-pixel line in character column 35 on
 STA SCBASE+&1F1F       \ character row 24, which is within the four-character
                        \ border to the right of the game screen and just within
                        \ the lower portion of the screen (where the dashboard
                        \ lives)
                        \
                        \ The palette for this part of the screen is black on
                        \ black, so the result isn't visible, and it's unclear
                        \ what this is for; perhaps it was a visual check used
                        \ during development to ensure that the border area was
                        \ indeed not showing any pixels
                        \
                        \ This write is manually reversed in the DEATH routine

 LDX #25                \ Set X = 25 so when we fall into BOX2, we draw the
                        \ left and right edges of the border box at a height of
                        \ 25 character rows rather than 18, so the box surrounds
                        \ the entire screen, and not just the space view portion

 EQUB &2C               \ Skip the first instruction of BOX2 by turning it into
                        \ &2C &A2 &12, or BIT &12A2, which does nothing apart
                        \ from affect the flags

                        \ Fall into BOX2 to draw the left and right edges of the
                        \ border box for the text view

