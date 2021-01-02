\ ******************************************************************************
\
\       Name: GRIDSET
\       Type: Subroutine
\   Category: Demo
\    Summary: Populate the line coordinate tables with the lines for the scroll
\             text
\
\ ------------------------------------------------------------------------------
\
\ This routine populates the X1TB, Y1TB, X2TB and Y2TB tables (the TB tables)
\ with the line coordinates that make up each character in the scroll text that
\ we want to display.
\
\ Arguments:
\
\   (Y X)               The contents of the scroll text to display
\
\ ******************************************************************************

.GRIDSET

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

.GSL1

 LDA P%,Y               \ This instruction was modified above to load the Y-th
                        \ character from the text we want to display into A, so
                        \ A now contains the ASCII code of the character we want
                        \ to process

 BEQ GRSEX              \ If A = 0 then we have reached the end of the text to
                        \ display, so jump down to GRSEX

 STY T                  \ Store the character index in T so we can retrieve it
                        \ later

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

 LDY T                  \ Retrieve the original character index from T into Y

 INY                    \ Increment the character index to point to the next
                        \ character in the text we want to display

 LDA XP                 \ Set XP = XP + #W2
 CLC                    \
 ADC #W2                \ to move the x-coordinate along by #WP (the horizontal
 STA XP                 \ character spacing for the scroll text)

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

.GRSEX

 LDA #0                 \ Set the X-th byte of Y1TB to 0 to indicate that we
 STA Y1TB,X             \ have reached the end of the scroll text

 RTS                    \ Return from the subroutine

