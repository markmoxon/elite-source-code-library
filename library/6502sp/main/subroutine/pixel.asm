\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Add a white dot at a specific distance to the pixel buffer
\             (2-pixel dash or 4-pixel square)
\
\ ------------------------------------------------------------------------------
\
\ Draw a point in white (cyan/red) at screen coordinate (X, A), with the point
\ size determined by the distance in ZZ, by adding it to the pixel buffer.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The screen x-coordinate of the point to draw
\
\   A                   The screen y-coordinate of the point to draw
\
\   ZZ                  The distance of the point (further away = smaller point)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PX4                 Contains an RTS
\
\ ******************************************************************************

.PIXEL

 STY T1                 \ Store Y in T1 so we can preserve it through the call
                        \ to PIXEL

 LDY PBUP               \ Set Y to the size of the pixel buffer

 STA PBUF+2,Y           \ Store the y-coordinate in PBUF+2

 TXA                    \ Store the x-coordinate in PBUF+1
 STA PBUF+1,Y

 LDA ZZ                 \ Store the distance in PBUF, with bits 0-2 cleared so
 AND #%11111000         \ the parasite's PIXEL routine will draw this point as a
 STA PBUF,Y             \ white 2-pixel dash or 4-pixel square

 TYA                    \ Set A = Y + 3
 CLC                    \       = PBUP + 3
 ADC #3

 STA PBUP               \ Update PBUP with the value in A, to grow the line
                        \ buffer by the three bytes we just added

 BMI PBFL               \ If A > 127, jump to PBFL to draw the pixels in the
                        \ pixel buffer

 LDY T1                 \ Restore the value of Y from T1, so it is preserved

.PX4

 RTS                    \ Return from the subroutine

