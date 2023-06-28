\ ******************************************************************************
\
\       Name: LOIN (Part 7 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and right or down and left
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going up and right (no swap) or down and left (swap)
\
\   * X1 >= X2 and Y1 >= Y2
\
\   * Draw from (X1, Y1) at bottom left to (X2, Y2) at top right
\
\ ******************************************************************************

.loin33

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 tileNumber) * 8
 STX SC+1               \             = (pattBufferHi 0) + tileNumber * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number tileNumber (as each tile contains 8 bytes
 ROL SC+1               \ of pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 CLC                    \ Clear the C flag for the additions below

 LDX Q                  \ Set X to the value of the x-axis counter

.loin34

 LDA R                  \ Fetch the pixel byte from R

 STA (SC),Y             \ Store R into screen memory at SC(1 0) - we don't need
                        \ to merge it with whatever is there, as we just started
                        \ drawing in a new tile

 DEX                    \ Decrement the y-coordinate counter in X

 BEQ loin32             \ If we have just reached the end of the line along the
                        \ y-axis, jump to loin32 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin35             \ If the addition didn't overflow, jump to loin35 to
                        \ skip the following

 ASL R                  \ Shift the single pixel in R to the left to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin40             \ If the pixel fell out of the left end of R into the
                        \ C flag, then jump to loin40 to rotate it into the
                        \ left end and move left by a character block

.loin35

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin34             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin34 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)


 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin35 using a BCC, or we passed through a
                        \ BCS to get to loin35, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on 
 SBC #31                \ the row above (as there are 32 tiles on each row)
 STA SC2
 BCS loin36
 DEC SC2+1

                        \ Fall through into loin36 to fetch the correct tile
                        \ number for the new character block and continue
                        \ drawing

.loin36

                        \ This is the entry point for this part (we jump here
                        \ from part 5 when the line is steep and X1 > X2)
                        \
                        \ We jump here with X containing the y-axis counter,
                        \ i.e. the number of steps we need to take along the
                        \ y-axis when drawing the line

 STX Q                  \ Store the updated y-axis counter in Q

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixel that we want to draw, then a tile
 BNE loin37             \ has already been allocated to this entry, so skip the
                        \ following

 LDA tileNumber         \ If tileNumber is zero then we have run out of tiles to
 BEQ loin41             \ use for drawing lines and pixels, so jump to loin41 to
                        \ keep going with the line-drawing calculations, but
                        \ without drawing anything in this tile

 STA (SC2,X)            \ Otherwise tileNumber contains the number of the next
                        \ available tile for drawing, so allocate this tile to
                        \ cover the pixel that we want to draw by setting the
                        \ nametable entry to the tile number we just fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw lines or pixels into a
                        \ tile

 JMP loin33             \ Jump to loin33 to calculate the pattern buffer address
                        \ for the new tile and continue drawing

.loin37

                        \ If we get here then we are drawing our line in a tile
                        \ that was already in the nametable buffer, so it might
                        \ contain pre-existing content

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 tileNumber) * 8
 STX SC+1               \             = (pattBufferHi 0) + tileNumber * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number tileNumber (as each tile contains 8 bytes
 ROL SC+1               \ of pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 CLC                    \ Clear the C flag for the additions below

 LDX Q                  \ Set X to the value of the x-axis counter

.loin38

                        \ We now loop along the line from right to left, using P
                        \ as a decreasing counter, and at each count we plot a
                        \ single pixel using the pixel mask in R

 LDA R                  \ Fetch the pixel byte from R

 ORA (SC),Y             \ Store R into screen memory at SC(1 0), using OR logic
 STA (SC),Y             \ so it merges with whatever is already on-screen

 DEX                    \ Decrement the y-coordinate counter in X

 BEQ loin45             \ If we have just reached the end of the line along the
                        \ y-axis, jump to loin45 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin39             \ If the addition didn't overflow, jump to loin39 to
                        \ skip the following

 ASL R                  \ Shift the single pixel in R to the left to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin40             \ If the pixel fell out of the left end of R into the
                        \ C flag, then jump to loin40 to rotate it into the
                        \ left end and move left by a character block

.loin39

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin38             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin38 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin39 using a BCC, or we passed through a
                        \ BCS to get to loin39, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on 
 SBC #31                \ the row above (as there are 32 tiles on each row) and
 STA SC2                \ jump to loin36 to fetch the correct tile number for
 BCS loin36             \ the new character block and continue drawing
 DEC SC2+1
 JMP loin36

.loin40

                        \ If we get here, then we just shifted the pixel out of
                        \ the left end of R, so we now need to put it back into
                        \ the right end of R and move to the left by one
                        \ character block

 ROL R                  \ We only reach here via a BCS, so this rotates a 1 into
                        \ the right end of R and clears the C flag


 LDA SC2                \ Decrement SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the left in the nametable buffer
 DEC SC2+1
 DEC SC2

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin36             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin36 to
                        \ draw the next pixel

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on 
 SBC #31                \ the row above (as there are 32 tiles on each row) and
 STA SC2                \ jump to loin36 to fetch the correct tile number for
 BCS loin36             \ the new character block and continue drawing
 DEC SC2+1
 JMP loin36

.loin41

                        \ If we get here then we have run out of tiles to
                        \ allocate to the line drawing, so we continue with the
                        \ same calculations, but don't actually draw anything in
                        \ this character block

 LDX Q

.loin42

 DEX                    \ Decrement the x-axis counter in X

 BEQ loin44             \ If we have just reached the end of the line along the
                        \ x-axis, jump to loin44 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin43             \ If the addition didn't overflow, jump to loin43 to
                        \ skip the following

 ASL R                  \ Shift the single pixel in R to the left to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin40             \ If the pixel fell out of the left end of R into the
                        \ C flag, then jump to loin40 to rotate it into the
                        \ left end and move left by a character block

.loin43

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin42             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin42 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin43 using a BCC, or we passed through a
                        \ BCS to get to loin43, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on 
 SBC #31                \ the row above (as there are 32 tiles on each row)
 STA SC2
 BCS P%+4
 DEC SC2+1

 JMP loin36             \ Jump to loin36 to fetch the correct tile number for
                        \ the new character block and continue drawing

.loin44

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 CLC                    \ Clear the C flag for the routine to return

 RTS                    \ Return from the subroutine

.loin45

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 CLC                    \ Clear the C flag for the routine to return

 RTS                    \ Return from the subroutine

