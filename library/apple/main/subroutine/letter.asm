\ ******************************************************************************
\
\       Name: letter
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a character in the high-resolution screen mode using the game
\             font
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The pixel x-coordinate of the letter we want to draw
\
\   YC                  The y-coordinate of the character as a text row number
\
\ ******************************************************************************

.letter

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95. The quickest way
                        \ to display text on-screen is to poke the character
                        \ pixel by pixel, directly into screen memory, so
                        \ that's what the rest of this routine does
                        \
                        \ The first step, then, is to get hold of the bitmap
                        \ definition for the character we want to draw on the
                        \ screen (i.e. we need the pixel shape of this
                        \ character)
                        \
                        \ The Apple II version of Elite uses its own unique font
                        \ which is embedded into this source code at page FONT,
                        \ so page 0 of the font is at FONT, page 1 is at
                        \ FONT+&100, and page 2 at FONT+&200
                        \
                        \ The following code reads the relevant character
                        \ bitmap from the copied font bitmaps at FONT and pokes
                        \ those values into the correct position in screen
                        \ memory, thus printing the character on-screen
                        \
                        \ It's a long way from 10 PRINT "Hello world!":GOTO 10

                        \ The following logic is easier to follow if we look
                        \ at the three character number ranges in binary:
                        \
                        \   Bit #  76543210
                        \
                        \   32  = %00100000     Page 0 of bitmap definitions
                        \   63  = %00111111
                        \
                        \   64  = %01000000     Page 1 of bitmap definitions
                        \   95  = %01011111
                        \
                        \   96  = %01100000     Page 2 of bitmap definitions
                        \   125 = %01111101
                        \
                        \ We'll refer to this below

 LDY #HI(FONT)-1        \ Set Y to point to the page before the first font page,
                        \ which is HI(FONT) - 1

 ASL A                  \ If bit 6 of the character is clear (A is 32-63)
 ASL A                  \ then skip the following instruction
 BCC P%+4

 LDY #HI(FONT)+1        \ A is 64-126, so set Y to point to the after the first
                        \ font page, which is HI(FONT) + 1

 ASL A                  \ If bit 5 of the character is clear (A is 64-95)
 BCC RR9                \ then skip the following instruction

 INY                    \ Increment Y

                        \ By this point, we started with Y = FONT-1, and then
                        \ we did the following:
                        \
                        \   If A = 32-63:   skip       then INX  so Y = FONT
                        \   If A = 64-95:   Y = FONT+1 then skip so Y = FONT+1
                        \   If A = 96-126:  Y = FONT+1 then INX  so Y = FONT+2
                        \
                        \ In other words, Y points to the relevant page. But
                        \ what about the value of A? That gets shifted to the
                        \ left three times during the above code, which
                        \ multiplies the number by 8 but also drops bits 7, 6
                        \ and 5 in the process. Look at the above binary
                        \ figures and you can see that if we cleared bits 5-7,
                        \ then that would change 32-53 to 0-31... but it would
                        \ do exactly the same to 64-95 and 96-125. And because
                        \ we also multiply this figure by 8, A now points to
                        \ the start of the character's definition within its
                        \ page (because there are 8 bytes per character
                        \ definition)
                        \
                        \ Or, to put it another way, Y contains the high byte
                        \ (the page) of the address of the definition that we
                        \ want, while A contains the low byte (the offset into
                        \ the page) of the address

.RR9

\CLC                    \ These instructions are commented out in the original
\ADC #LO(FONT)          \ source

 STA P                  \ Set the low byte of P(1 0) to A

\BCC P%+3               \ These instructions are commented out in the original
\INY                    \ source

 STY P+1                \ Set the high byte of P(1 0) to Y, so P(1 0) = (Y A)

                        \ Fall through into letter2 to draw the character at
                        \ address P(1 0) in the high-resolution screen mode

