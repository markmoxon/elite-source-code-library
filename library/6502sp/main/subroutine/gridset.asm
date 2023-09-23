\ ******************************************************************************
\
\       Name: GRIDSET
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Demo
\    Summary: Populate the line coordinate tables with the lines for the scroll
\             text
ELIF _NES_VERSION
\   Category: Combat demo
\    Summary: Populate the line coordinate tables with the pixel lines for one
\             21-character line of scroll text
ENDIF
\  Deep dive: The 6502 Second Processor demo mode
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ This routine populates the X1TB, Y1TB, X2TB and Y2TB tables (the TB tables)
\ with the line coordinates that make up each character in the scroll text that
\ we want to display.
ELIF _NES_VERSION
\ This routine populates the X-th byte in the X1TB, Y1TB and X2TB tables (the TB
\ tables) with the line coordinates that make up each character in a single line
\ of scroll text that we want to display (where each line of text contains 21
\ characters).
ENDIF
\
\ Arguments:
\
IF NOT(_NES_VERSION)
\   (Y X)               The contents of the scroll text to display
ELIF _NES_VERSION
\   INF(1 0)            The contents of the scroll text to display
\
\   XC                  The offset within INF(1 0) of the 21-character line of
\                       text to display
\
\ Other entry points:
\
\   GRIDSET+5           Use the y-coordinate in YP so the scroll text starts at
\                       (0, YP) rather than (0, 6)
ENDIF
\
\ ******************************************************************************

.GRIDSET

IF NOT(_NES_VERSION)

 STX GSL1+1             \ Modify the LDA instruction at GSL1 below to point to
 STY GSL1+2             \ (Y X) instead of P%, i.e. to the Y-th character of the
                        \ text we want to display

 LDA #254               \ Set YP = 254
 STA YP

 LDY #0                 \ Set Y = 0, to act as an index into the text we want
                        \ to display, pointing to the character we are currently
                        \ processing

 LDX #0                 \ Set X = 0, to act as a pointer when populating the TB
                        \ tables with one byte per character

 STX XP                 \ Set XP = 0, so we now have (XP, YP) = (0, 254)
                        \
                        \ (XP, YP) is the coordinate in space where we start
                        \ drawing the lines that make up the scroll text, so
                        \ this effectively moves the scroll text cursor to the
                        \ top-left corner (as these are space coordinates where
                        \ higher y-coordinates are further up the screen)

ELIF _NES_VERSION

 LDX #6                 \ Set YP = 6
 STX YP

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #21                \ Each line line of text in the scroll text contains 21
 STX CNT                \ characters (padded out with spaces if required), so
                        \ set CNT = 21 to use as a counter to work through the
                        \ line of text at INF(1 0) + XC

 LDX #0                 \ Set XP = 0, so we now have (XP, YP) = (0, 6)
 STX XP                 \
                        \ (XP, YP) is the coordinate in space where we start
                        \ drawing the lines that make up the scroll text, so
                        \ this effectively moves the scroll text cursor to the
                        \ top-left corner (as these are space coordinates where
                        \ higher y-coordinates are further up the screen) ???

 LDY XC                 \ Set Y = XC, to act as an index into the text we want
                        \ to display, pointing to the character we are currently
                        \ processing and starting from character XC

ENDIF

.GSL1

IF NOT(_NES_VERSION)

 LDA P%,Y               \ This instruction was modified above to load the Y-th
                        \ character from the text we want to display into A, so
                        \ A now contains the ASCII code of the character we want
                        \ to process

 BEQ GRSEX              \ If A = 0 then we have reached the end of the text to
                        \ display, so jump down to GRSEX

 STY T                  \ Store the character index in T so we can retrieve it
                        \ later

ELIF _NES_VERSION

 LDA (INF),Y            \ Load the Y-th character from the text we want to
                        \ display into A, so A now contains the ASCII code of
                        \ the character we want to process

 BPL grid1              \ If bit 7 of the character is clear, jump to grid1 to
                        \ slip the following

 TAX                    \ Bit 7 of the character is set, so set A to character
 LDA K5-128,X           \ X - 128 from K5
                        \
                        \ So character &80 refers to location K5, &81 to K5+1,
                        \ &82 to K5+2 and &83 to K5+3, which is where we put the
                        \ results for the time taken in the combat demo, so this
                        \ allows us to display the time in the scrolltext

.grid1

ENDIF

IF NOT(_NES_VERSION)

 SEC                    \ Set S = A - ASCII ",", as the table at LTDEF starts
 SBC #','               \ with the lines needed for a comma, so A now contains
 STA S                  \ the number of the entry in LTDEF for this character

 ASL A                  \ Set Y = S + 4 * A
 ASL A                  \       = A + 4 * A
 ADC S                  \       = 5 * A
 TAY                    \
                        \ so Y now points to the offset of the definition in the
                        \ LTDEF table for the character in A, where the first
                        \ character in the table is a comma and each definition
                        \ in LTDEF consists of five bytes

ELIF _NES_VERSION

 SEC                    \ Set S = A - ASCII " ", as the table at LTDEF starts
 SBC #' '               \ with the lines needed for a space, so A now contains
 STA S                  \ the number of the entry in LTDEF for this character

 ASL A                  \ Set Y = S + 4 * A
 ASL A                  \       = A + 4 * A
 ADC S                  \       = 5 * A
 BCS grid2              \
 TAY                    \ so Y now points to the offset of the definition in the
                        \ LTDEF table for the character in A, where the first
                        \ character in the table is a space and each definition
                        \ in LTDEF consists of five bytes
                        \
                        \ If the addition overflows, jump to grid2 to do the
                        \ same as the following, but with an extra &100 added
                        \ to the addresses to cater for the overflow

ENDIF

 LDA LTDEF,Y            \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ first line into the TB tables

 LDA LTDEF+1,Y          \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ second line into the TB tables

 LDA LTDEF+2,Y          \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ third line into the TB tables

 LDA LTDEF+3,Y          \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ fourth line into the TB tables

 LDA LTDEF+4,Y          \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ fifth line into the TB tables

IF NOT(_NES_VERSION)

 LDY T                  \ Retrieve the original character index from T into Y

 INY                    \ Increment the character index to point to the next
                        \ character in the text we want to display

ELIF _NES_VERSION

 INC XC                 \ Increment the character index to point to the next
                        \ character in the text we want to display

 LDY XC                 \ Set Y to the updated character index

ENDIF

 LDA XP                 \ Set XP = XP + #W2
 CLC                    \
 ADC #W2                \ to move the x-coordinate along by #W2 (the horizontal
 STA XP                 \ character spacing for the scroll text)

IF NOT(_NES_VERSION)

 BCC GSL1               \ If the addition didn't overflow (i.e. XP < 256) loop
                        \ back to GSL1

 LDA #0                 \ Otherwise we just reached the end of a line in the
 STA XP                 \ scroll text, so set XP = 0 to move the scroll text
                        \ cursor to the start of the line

 LDA YP                 \ And set YP = YP - #W2Y to move the scroll text cursor
 SBC #W2Y               \ down by one line (as #W2Y is the scroll text's
 STA YP                 \ vertical line spacing)

 JMP GSL1               \ Loop back to GSL1 to process the next character in the
                        \ scroll text

ELIF _NES_VERSION

 DEC CNT                \ Decrement the loop counter in CNT

 BNE GSL1               \ Loop back to process the next character until we have
                        \ done all 21

 RTS                    \ Return from the subroutine

ENDIF

IF NOT(_NES_VERSION)

.GRSEX

 LDA #0                 \ Set the X-th byte of Y1TB to 0 to indicate that we
 STA Y1TB,X             \ have reached the end of the scroll text

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

.grid2

                        \ If we get here then the addition overflowed when
                        \ calculating A, so we need to add an extra &100 to A
                        \ to get the correct address in LTDEF

 TAY                    \ Copy A to Y, so Y points to the offset of the
                        \ definition in the LTDEF table for the character in A

 LDA LTDEF+&100,Y       \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ first line into the TB tables

 LDA LTDEF+&101,Y       \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ second line into the TB tables

 LDA LTDEF+&102,Y       \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ third line into the TB tables

 LDA LTDEF+&103,Y       \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ fourth line into the TB tables

 LDA LTDEF+&104,Y       \ Call GRS1 to put the coordinates of the character's
 JSR GRS1               \ fifth line into the TB tables

 INC XC                 \ Increment the character index to point to the next
                        \ character in the text we want to display

 LDY XC                 \ Set Y to the updated character index

 LDA XP                 \ Set XP = XP + #W2
 CLC                    \
 ADC #W2                \ to move the x-coordinate along by #W2 (the horizontal
 STA XP                 \ character spacing for the scroll text)

 DEC CNT                \ Decrement the loop counter in CNT

 BNE GSL1               \ Loop back to process the next character until we have
                        \ done all 21

 RTS                    \ Return from the subroutine

ENDIF

