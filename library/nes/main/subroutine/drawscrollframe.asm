\ ******************************************************************************
\
\       Name: DrawScrollFrame
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Draw one frame of the scroll text
\  Deep dive: The NES combat demo
\
\ ------------------------------------------------------------------------------
\
\ This routine draws each character on the scroll text by taking the character's
\ line coordinates from the from the X1TB, X2TB and Y1TB line coordinate tables
\ (i.e. X1, Y1, X2 and Y2) and projecting them onto a scroll that disappears
\ into the distance, like the scroll text at the start of Star Wars.
\
\ For a character line from (X1, Y1) to (X2, Y2), the calculation gives us
\ coordinates of the line to draw on-screen from (x1, y1) to (x2, y2), as
\ follows:
\
\                                256 * (X1 - 32)
\   x1 = XX15(1 0) = 128 + ----------------------------
\                          Y1 * 8 + 31 - scrollProgress
\
\                                256 * (X2 - 32)
\   x2 = XX15(5 4) = 128 + ----------------------------
\                          Y2 * 8 + 31 - scrollProgress
\
\                          37 - Y1 * 2 + scrollProgress / 4
\   y1 = XX15(3 2) = 72 + ----------------------------------
\                         2 * (31 + Y1 * 8 - scrollProgress)
\
\                          37 - Y2 * 2 + scrollProgress / 4
\   y2 = XX12(1 0) = 72 + ----------------------------------
\                         2 * (31 + Y2 * 8 - scrollProgress)
\
\ The line then gets clipped to the screen by the CLIP_b1 routine and drawn.
\
\ ******************************************************************************

.DrawScrollFrame

 JSR GetScrollDivisions \ Set up the division calculations for the scroll text
                        \ and store then in the 16 bytes at BUF and the 16 bytes
                        \ at BUF+16

 LDY #&FF               \ We are about to loop through the 240 bytes in the line
                        \ coordinate tables, so set a coordinate counter in Y
                        \ to start from 0, so set Y = -1 so the INY instruction
                        \ at the start of the loop sets Y to 0 for the first
                        \ coordinate

.drfr1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 INY                    \ Increment the coordinate counter in Y

 CPY #240               \ If Y = 240 then we have worked our way through all the
 BEQ RTS10              \ line coordinates, so jump to RTS10 to return from the
                        \ subroutine

 LDA Y1TB,Y             \ Set A to the y-coordinate byte that contains the start
                        \ and end y-coordinates in the bottom and high nibbles
                        \ respectively

 BEQ drfr1              \ If both y-coordinates are zero then this entry doesn't
                        \ contain a line, so jump to drfr1 to move on to the
                        \ next coordinate

                        \ We now set up the following, so we can clip the line
                        \ to the screen before drawing it:
                        \
                        \   XX15(1 0) = X1 as a 16-bit coordinate (x1_hi x1_lo)
                        \
                        \   XX15(3 2) = Y1 as a 16-bit coordinate (y1_hi y1_lo)
                        \
                        \   XX15(5 4) = X2 as a 16-bit coordinate (x2_hi x2_lo)
                        \
                        \   XX12(1 0) = Y2 as a 16-bit coordinate (y2_hi y2_lo)
                        \
                        \ We calculate these values from the X1TB, X2TB and Y1TB
                        \ line coordinate values for the line we want to draw
                        \ (where Y1TB contains the Y1 and Y2 y-coordinates, one
                        \ in each nibble)

 AND #&0F               \ Set Y1 to the low nibble of A, which contains the
 STA Y1                 \ y-coordinate of the start of the line, i.e. Y1

 TAX                    \ Set X to the y-coordinate of the start of the line, Y1

 ASL A                  \ Set A = A * 8 - scrollProgress
 ASL A                  \       = Y1 * 8 - scrollProgress
 ASL A
 SEC
 SBC scrollProgress

 BCC drfr1              \ If the subtraction underflowed then this coordinate is
                        \ not on-screen, so jump to drfr1 to move on to the next
                        \ coordinate

 STY YP                 \ Store the loop counter in YP, so we can retrieve it at
                        \ the end of the loop

 LDA BUF+16,X           \ Set Q to the entry from BUF+16 for the y-coordinate in
 STA Q                  \ X (which we set to Y1 above), so:
                        \
                        \   Q = X * 8 + 31 - scrollProgress
                        \     = Y1 * 8 + 31 - scrollProgress

 LDA X1TB,Y             \ Set A to the x-coordinate of the start of the line, X1

 JSR ProjectScrollText  \ Set (A X) = 128 + 256 * (A - 32) / Q
                        \           = 128 + 256 * (X1 - 32) / Q
                        \
                        \ So (A X) is the x-coordinate of the start of the line,
                        \ projected onto the scroll text so coordinates bunch
                        \ together horizontally the further up the scroll text
                        \ they are

 STX XX15               \ Set the low byte of XX15(1 0) to X

 LDX Y1                 \ Set X = Y1, which we set to the y-coordinate of the
                        \ start of the line, i.e. Y1

 STA XX15+1             \ Set the high byte of XX15(1 0) to A, so we have:
                        \
                        \   XX15(1 0) = (A X)
                        \                           256 * (X1 - 32)
                        \             = 128 + ----------------------------
                        \                     Y1 * 8 + 31 - scrollProgress

 LDA BUF,X              \ Set the low byte of XX15(3 2) to the entry from BUF+16
 STA XX15+2             \ for the y-coordinate in X (which we set to Y1 above)

 LDA #0                 \ Set the high byte of XX15(3 2) to 0
 STA XX15+3             \
                        \ So we now have:
                        \
                        \                     37 - Y1 * 2 + scrollProgress / 4
                        \   XX15(3 2) = 72 + ----------------------------------
                        \                    2 * (31 + Y1 * 8 - scrollProgress)

 LDA Y1TB,Y             \ Set A to the combined y-coordinates of the start and
                        \ end of the line, Y1 and Y2, with one in each nibble

 LSR A                  \ Set the high byte of XX12(1 0) to the high nibble of
 LSR A                  \ A, which contains the y-coordinate of the end of the
 LSR A                  \ line, i.e. Y2
 LSR A
 STA XX12+1

 TAX                    \ Set X to the y-coordinate of the end of the line, Y2

 ASL A                  \ Set A = XX12+1 * 8 - scrollProgress
 ASL A                  \       = Y2 * 8 - scrollProgress
 ASL A
 SEC
 SBC scrollProgress

 BCC drfr1              \ If the subtraction underflowed then this coordinate is
                        \ not on-screen, so jump to drfr1 to move on to the next
                        \ coordinate

 LDA BUF,X              \ Set the low byte of XX12(1 0) to the entry from BUF+16
 STA XX12               \ for the y-coordinate in X (which we set to Y2 above)

 LDA #0                 \ Set X to XX12+1, which we set to Y2 above, so X = Y2
 LDX XX12+1

 STA XX12+1             \ Set the high byte of XX12(1 0) to 0
                        \
                        \ So we now have:
                        \
                        \                     37 - Y2 * 2 + scrollProgress / 4
                        \   XX12(1 0) = 72 + ----------------------------------
                        \                    2 * (31 + Y2 * 8 - scrollProgress)

 LDA BUF+16,X           \ Set Q to the entry from BUF+16 for the y-coordinate in
 STA Q                  \ X (which we set to Y2 above), so:
                        \
                        \   Q = X * 8 + 31 - scrollProgress
                        \     = Y2 * 8 + 31 - scrollProgress

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA X2TB,Y             \ Set A to the x-coordinate of the end of the line, X2

 JSR ProjectScrollText  \ Set (A X) = 128 + 256 * (A - 32) / Q
                        \           = 128 + 256 * (X1 - 32) / Q
                        \
                        \ So (A X) is the x-coordinate of the end of the line,
                        \ projected onto the scroll text so coordinates bunch
                        \ together horizontally the further up the scroll text
                        \ they are

 STX XX15+4             \ Set XX15(5 4) = (A X)
 STA XX15+5             \                           256 * (X2 - 32)
                        \             = 128 + ----------------------------
                        \                     Y2 * 8 + 31 - scrollProgress

 JSR CLIP_b1            \ Clip the following line to fit on-screen:
                        \
                        \   XX15(1 0) = x1 as a 16-bit coordinate (x1_hi x1_lo)
                        \
                        \   XX15(3 2) = y1 as a 16-bit coordinate (y1_hi y1_lo)
                        \
                        \   XX15(5 4) = x2 as a 16-bit coordinate (x2_hi x2_lo)
                        \
                        \   XX12(1 0) = y2 as a 16-bit coordinate (y2_hi y2_lo)
                        \
                        \ and draw the line from (X1, Y1) to (X2, Y2) once it's
                        \ clipped

 LDY YP                 \ Set Y to the loop counter that we stored in YP above

 JMP drfr1              \ Loop back to drfr1 to process the next coordinate

