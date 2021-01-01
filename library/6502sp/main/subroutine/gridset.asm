\ ******************************************************************************
\
\       Name: GRIDSET
\       Type: Subroutine
\   Category: Demo
\    Summary: Generate the line coordinates for the scroll text
\
\ ------------------------------------------------------------------------------
\
\ This routine populates the X1TB/Y1TB/X2TB/Y2TB tables with the coordinates of
\ up to five lines for each character in the scroll text that we want to
\ display.
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

 LDX #0                 \ Set X = 0, to act as a pointer when populating the
                        \ X1TB/Y1TB/X2TB/Y2TB tables with one byte per character

 STX XP                 \ Set XP = 0

.GSL1

 LDA P%,Y               \ This instruction was modified above to load the Y-th
                        \ character from the text we want to display into A, so
                        \ A now contains the ASCII code of the character we want
                        \ to process

 BEQ GRSEX              \ If A = 0, which means we have reached the end of the
                        \ text to display, then jump down to GRSEX

 STY T                  \ Store the character index in T so we can retrieve it
                        \ later

 SEC                    \ Set S = A - ASCII ",", as the table at LTDEF starts
 SBC #','               \ with the lines needed for a comma
 STA S

 ASL A                  \ Set Y = S + 4 * A
 ASL A                  \       = A + 4 * A
 ADC S                  \       = 5 * A
 TAY                    \
                        \ so Y now points to the offset of the definition in the
                        \ LTDEF table for the character in A, where the first
                        \ character in the table is a comma and each definition
                        \ in LTDEF consists of five bytes

 LDA LTDEF,Y            \ Call GRS1 to copy the coordinates of the character's
 JSR GRS1               \ first line from LTDEF into the coordinate tables at
                        \ X1TB/Y1TB/X2TB/Y2TB

 LDA LTDEF+1,Y          \ Call GRS1 to copy the coordinates of the character's
 JSR GRS1               \ second line from LTDEF into the coordinate tables at
                        \ X1TB/Y1TB/X2TB/Y2TB

 LDA LTDEF+2,Y          \ Call GRS1 to copy the coordinates of the character's
 JSR GRS1               \ third line from LTDEF into the coordinate tables at
                        \ X1TB/Y1TB/X2TB/Y2TB

 LDA LTDEF+3,Y          \ Call GRS1 to copy the coordinates of the character's
 JSR GRS1               \ fourth line from LTDEF into the coordinate tables at
                        \ X1TB/Y1TB/X2TB/Y2TB

 LDA LTDEF+4,Y          \ Call GRS1 to copy the coordinates of the character's
 JSR GRS1               \ fifth line from LTDEF into the coordinate tables at
                        \ X1TB/Y1TB/X2TB/Y2TB

 LDY T                  \ Retrieve the original character index from T into Y

 INY                    \ Increment the character index to point to the next
                        \ character in the text we want to display

 LDA XP                 \ Set XP = XP + #W2
 CLC                    \
 ADC #W2                \ to move the x-coordinate along by #WP
 STA XP

 BCC GSL1               \ If the addition didn't overflow (i.e. XP < 256) loop
                        \ back to GSL1

 LDA #0                 \ Set XP = 0
 STA XP

 LDA YP                 \ Set YP = YP - #W2Y
 SBC #W2Y               \
 STA YP                 \ to move the y-coordinate down by one line

 JMP GSL1               \ Loop back to GSL1

.GRSEX

 LDA #0                 \ Set the X-th byte of Y1TB = 0
 STA Y1TB,X

 RTS                    \ Return from the subroutine

