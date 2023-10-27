\ ******************************************************************************
\
\       Name: LOIN (Part 4 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a shallow line going right and down or left and up
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going right and down (no swap) or left and up (swap)
\
\   * X1 < X2 and Y1 <= Y2
\
\   * Draw from (X1, Y1) at top left to (X2, Y2) at bottom right
\
\ ******************************************************************************

.DOWN

 LDA X1                 \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + X1 / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and X1 / 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (X1, Y), i.e. the line we are drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set

.loin10

 STA R                  \ Store the pixel byte in R

.loin11

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixel that we want to draw, then a
 BNE loin12             \ pattern has already been allocated to this entry, so
                        \ skip the following

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ loin16             \ patterns to use for drawing lines and pixels, so jump
                        \ to loin16 to move on to the next pixel in the line

 STA (SC2,X)            \ Otherwise firstFreePattern contains the number of the
                        \ next available pattern for drawing, so allocate this
                        \ pattern to cover the pixel that we want to draw by
                        \ setting the nametable entry to the pattern number we
                        \ just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be added to
                        \ the nametable the next time we need to draw lines or
                        \ pixels into a pattern

.loin12

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 CLC                    \ Clear the C flag for the additions below

.loin13

                        \ We now loop along the line from left to right, using P
                        \ as a decreasing counter, and at each count we plot a
                        \ single pixel using the pixel mask in R

 LDA R                  \ Fetch the pixel byte from R

 ORA (SC),Y             \ Store R into screen memory at SC(1 0), using OR logic
 STA (SC),Y             \ so it merges with whatever is already on-screen

 DEC P                  \ Decrement the x-axis counter in P

 BEQ loin9              \ If we have just reached the end of the line along the
                        \ x-axis, jump to loin9 to return from the subroutine

 LDA S                  \ Set S = S + Q to update the slope error
 ADC Q
 STA S

 BCC loin14             \ If the addition didn't overflow, jump to loin14 to
                        \ skip the following

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 CPY #8                 \ If Y = 8 then we have just gone past the bottom of the
 BEQ loin15             \ character block, so jump to loin15 to move to the next
                        \ row of nametable entries (jumping back to loin10
                        \ afterwards)

.loin14

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BNE loin13             \ If the pixel didn't fall out of the right end of R,
                        \ then the pixel byte is still non-zero, so loop back
                        \ to loin13

 LDA #%10000000         \ Set a pixel byte in A with the leftmost pixel set, as
                        \ we need to move to the next character block along

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE loin10             \ the right in the nametable buffer and jump up to
 INC SC2+1              \ loin10 to fetch the tile details for the new nametable
 JMP loin10             \ entry

.loin15

                        \ If we get here then we have just gone past the bottom
                        \ of the character block
                        \
                        \ At this point the C flag is set, as we jumped here
                        \ using a BEQ, so the ADC #31 below actually adds 32

 LDA SC2                \ If we get here then we need to move down into the
 ADC #31                \ character block above, so we add 32 to SC2(1 0)
 STA SC2                \ to get the tile number on the row above (as there are
 BCC P%+4               \ 32 tiles on each row)
 INC SC2+1

 LDY #0                 \ Set the pixel line in Y to the first line in the new
                        \ character block

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BNE loin11             \ If the pixel didn't fall out of the right end of R,
                        \ then the pixel byte is still non-zero, so loop back
                        \ to loin11

 LDA #%10000000         \ Set a pixel byte in A with the leftmost pixel set, as
                        \ we need to move to the next character block along

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE loin10             \ the right in the nametable buffer and jump up to
 INC SC2+1              \ loin10 to fetch the tile details for the new nametable
 JMP loin10             \ entry

.loin16

                        \ If we get here then we have run out of tiles to
                        \ allocate to the line drawing, so we continue with the
                        \ same calculations, but don't actually draw anything in
                        \ this character block

 DEC P                  \ Decrement the x-axis counter in P

 BEQ loin19             \ If we have just reached the end of the line along the
                        \ x-axis, jump to loin19 to return from the subroutine

 CLC                    \ Set S = S + Q to update the slope error
 LDA S
 ADC Q
 STA S

 BCC loin17             \ If the addition didn't overflow, jump to loin17 to
                        \ skip the following

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 CPY #8                 \ If Y = 8 then we have just gone past the bottom of the
 BEQ loin15             \ character block, so jump to loin15 to move to the next
                        \ row of nametable entries (jumping back to loin10
                        \ afterwards)

.loin17

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BNE loin16             \ If the pixel didn't fall out of the right end of R,
                        \ then the pixel byte is still non-zero, so loop back
                        \ to loin16

 LDA #%10000000         \ Set a pixel byte in A with the leftmost pixel set, as
                        \ we need to move to the next character block along

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer and jump up to
 INC SC2+1              \ loin10 to fetch the tile details for the new nametable
 JMP loin10             \ entry

.loin18

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

.loin19

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 CLC                    \ Clear the C flag for the routine to return

 RTS                    \ Return from the subroutine

