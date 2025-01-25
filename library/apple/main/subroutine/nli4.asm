\ ******************************************************************************
\
\       Name: NLI4
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line of dashes underneath a title on the text screen
\
\ ******************************************************************************

.NLI4

 LDX #39                \ We want to draw a line of dashes underneath the text
                        \ title, so set a column counter in X to work from the
                        \ right side of the screen to the left, from column 39
                        \ to 0, so we can draw the line one character at a time

.NLL1

 LDA &480,X             \ We only want to draw a dashes underneath characters in
                        \ the title, so set A to the character in column X of
                        \ the page title
                        \
                        \ The title is in row 1 of the screen (the second row),
                        \ which lives at memory location &480 in screen memory,
                        \ so this fetches the character at column X on row 1

 CMP #160               \ When we clear the text screen in the TTX66K routine,
 BEQ NLI5               \ we do this by filling it with character 160, so this
                        \ jumps to NLI5 to skip the following if the character
                        \ we just fetched is blank

 LDA #'-'+128           \ If we get here then there is a character in the title
 STA &500,X             \ in column X, so draw a dash in the same column in the
                        \ row below (which is row 2, at memory location &500 in
                        \ screen memory)
                        \
                        \ We add 128 to the ASCII code for a dash to set bit 7,
                        \ so the character is displayed in normal video (white
                        \ characters on a black background)

.NLI5

 DEX                    \ Decrement the column counter in X to move left to the
                        \ next text column

 BPL NLL1               \ Loop back until we have reached the start of the row

 RTS                    \ Return from the subroutine

