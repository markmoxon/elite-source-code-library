\ ******************************************************************************
\
\       Name: PIXEL3
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Add a coloured dot at a specific distance to the pixel buffer
\             (1-pixel dot, 2-pixel dash or 4-pixel square)
\
\ ------------------------------------------------------------------------------
\
\ Draw a point at screen coordinate (X, A), with the point size and colour being
\ determined by the distance in ZZ, by adding it to the pixel buffer.
\
\ Arguments:
\
\   X                   The screen x-coordinate of the point to draw
\
\   A                   The screen y-coordinate of the point to draw
\
\   ZZ                  The distance of the point (further away = smaller point)
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.PIXEL3

 STY T1                 \ Store Y in T1 so we can preserve it through the call
                        \ to PIXEL3

 LDY PBUP               \ Set Y to the size of the pixel buffer

 STA PBUF+2,Y           \ Store the y-coordinate in PBUF+2

 TXA                    \ Store the x-coordinate in PBUF+2
 STA PBUF+1,Y

 LDA ZZ                 \ Store the distance in PBUF, making sure bit 0 is set
 ORA #1                 \ so the parasite's PIXEL routine will draw this dot
 STA PBUF,Y             \ using the distance to determine the dot's size and
                        \ colour

 TYA                    \ Set A = Y + 3
 CLC                    \       = PBUP + 3
 ADC #3

 STA PBUP               \ Update PBUP with the value in A, to grow the line
                        \ buffer by the three bytes we just added

 BMI PBFL               \ If A > 127, jump to PBFL to draw the pixels in the
                        \ pixel buffer

 LDY T1                 \ Restore the value of Y from T1, so it is preserved

 RTS                    \ Return from the subroutine

