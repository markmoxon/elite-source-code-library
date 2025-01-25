\ ******************************************************************************
\
\       Name: letter2
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a character or indicator bulb bitmap in the high-resolution
\             screen mode
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The pixel x-coordinate of the character we want to draw
\
\   YC                  The y-coordinate of the character as a text row number
\
\   P(1 0)              The address of the character definition to be drawn
\
\ ******************************************************************************

.letter2

 LDY YC                 \ Set the low byte of SC(1 0) to the YC-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row YC in screen memory

 LDA SCTBH,Y            \ Set the high byte of SC(1 0) to the Y-th entry from
 STA SC+1               \ SCTBH, which contains the high byte of the address of
                        \ the start of character row YC in screen memory

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set P+2 to the bit
 STY P+2                \ number within the pixel byte that corresponds to the
                        \ pixel at the start of the character (as X contains the
                        \ x-coordinate of the character we want to draw)

 LDY SCTBX2,X           \ Using the lookup table at SCTBX2, set T1 to the byte
 STY T1                 \ number within the pixel row that contains the start of
                        \ the character (as X contains the x-coordinate of the
                        \ character we want to draw)

 LDY #0                 \ We want to print the 8 bytes of the character bitmap
                        \ to the screen (one byte per pixel row), so set up a
                        \ counter in Y to count through the character bitmap
                        \ pixel rows, starting from the top and working
                        \ downwards

.RRL1

 LDA #0                 \ Set T3 = 0, to use as the pixel pattern for the second
 STA T3                 \ pixel byte to the right (as the 8-bit wide character
                        \ will span two seven-pixel character blocks)

 LDA (P),Y              \ The character definition is at P(1 0), so load the
                        \ Y-th byte from P(1 0), which will contain the bitmap
                        \ for the Y-th row of the character

                        \ We now take this 8-bit pixel pattern and position it
                        \ correctly within two seven-bit high-resolution screen
                        \ bytes, so we can poke it into screen memory
                        \
                        \ The first byte (on the left) will be in A, and the
                        \ second byte (on the right) will be in T3
                        \
                        \ To understand the following, consider two seven-pixel
                        \ bytes side-by-side in the high-resolution screen, like
                        \ this (omitting bit 7 for clarity):
                        \
                        \   xxxxxxx 0000000
                        \
                        \ In this example, the pixel byte on the left contains
                        \ all set pixels, while the pixel byte on the right
                        \ contains all clear pixels
                        \
                        \ If we want to shift the pixels along to the right
                        \ on-screen, then we need to consider how this is laid
                        \ out in terms of bit numbers:
                        \
                        \   0     6 0     6
                        \   xxxxxxx 0000000
                        \
                        \ So to shift the pattern along, we need to do this:
                        \
                        \   0     6 0     6
                        \   0xxxxxx x000000
                        \
                        \ In other words, we shift bits out of the high end of
                        \ the first byte (i.e. out of bit 6), and into the low
                        \ end of the second byte (i.e. into bit 0)
                        \
                        \ This is a bit counterintuitive, but it's what we need
                        \ to do in order to shift our character bitmap byte in A
                        \ so that it's split correctly across the two-byte
                        \ sequence of A on the left and T3 on the right (and the
                        \ byte on the left in A contains eight full bits of data
                        \ rather than seven)

 LDX P+2                \ Set X to the bit number within the pixel byte that
                        \ corresponds to the pixel at the start of the character
                        \ (which we stored in P+2 above)
                        \
                        \ This is the number of shifts we need to apply to the
                        \ two-byte sequence A T3, shifting the bits as above,
                        \ so we use this as a shift counter in the following

.RRL2

 CMP #128               \ If the bitmap byte in A is >= 128, set the C flag,
                        \ otherwise clear it, so this sets the C flag to bit 7
                        \ of the 8-bit character bitmap in A

 ROL T3                 \ Shift the result left into bit 0 of T3, which is the
                        \ same shifting a pixel right into the leftmost pixel of
                        \ the right pixel byte (as described above)

 DEX                    \ Decrement the shift counter in X

 BMI RR8                \ If we have performed all X shifts then jump to RR8 to
                        \ stop shifting (but note that we have not shifted A to
                        \ the left by this point)

 ASL A                  \ Shift the bitmap byte in A to the left, so we have now
                        \ shifted the whole two-byte sequence

 JMP RRL2               \ Loop back for the next left shift

.RR8

 AND #%01111111         \ Clear bit 7 of the pixel byte to set the colour
                        \ palette of the left pixel byte to 0
                        \
                        \ This works because we didn't perform the last shift in
                        \ the above process, so bit 7 has already been moved
                        \ into T3 and can be overwritten with the palette number

                        \ We now have two bytes, in A and T3, that are suitable
                        \ for poking into screen memory to draw this pixel row
                        \ of the character on-screen

 CLC                    \ Clear the C flag for the addition below

 STY T2                 \ Store the character bitmap pixel row in T2, so we can
                        \ retrieve it below

 LDY T1                 \ Set Y to the byte number within the pixel row that
                        \ contains the start of the character, which we stored
                        \ in T1 above

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen
                        \
                        \ So this draws the left pixel byte for this pixel row
                        \ of the character

 INY                    \ Increment Y to point to the next pixel byte along to
                        \ the right

 LDA T3                 \ Set A to the pixel pattern for the second pixel byte

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen
                        \
                        \ And this draws the right pixel byte for this pixel row
                        \ of the character

 LDY T2                 \ Set Y to the number of the character bitmap pixel row,
                        \ which we stored in T2 above

                        \ We now need to move down into the pixel row below

 LDA SC+1               \ Add 4 to the high byte of SC(1 0), so this does the
 ADC #4                 \ following:
 STA SC+1               \
                        \   SC(1 0) = SC(1 0) + &400
                        \
                        \ The addition works because we cleared the C flag above
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ below the one we just drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

 INY                    \ Increment Y to point to the next character bitmap
                        \ pixel row, working down the character bitmap

 CPY #8                 \ Loop back until we have drawn all eight pixel rows in
 BNE RRL1               \ the character

 RTS                    \ Return from the subroutine

