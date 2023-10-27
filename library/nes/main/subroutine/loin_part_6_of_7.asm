
\ ******************************************************************************
\
\       Name: LOIN (Part 6 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and left or down and right
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going up and left (no swap) or down and right (swap)
\
\   * X1 < X2 and Y1 >= Y2
\
\   * Draw from (X1, Y1) at top left to (X2, Y2) at bottom right
\
\ ******************************************************************************

.loin20

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 CLC                    \ Clear the C flag for the routine to return

 RTS                    \ Return from the subroutine

.loin21

                        \ If we get here then we are drawing our line in a new
                        \ pattern, so it won't contain any pre-existing content

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

 LDX Q                  \ Set X to the value of the x-axis counter

.loin22

 LDA R                  \ Fetch the pixel byte from R

 STA (SC),Y             \ Store R into screen memory at SC(1 0) - we don't need
                        \ to merge it with whatever is there, as we just started
                        \ drawing in a new tile

 DEX                    \ Decrement the y-coordinate counter in X

 BEQ loin20             \ If we have just reached the end of the line along the
                        \ y-axis, jump to loin20 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin23             \ If the addition didn't overflow, jump to loin23 to
                        \ skip the following

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin28             \ If the pixel fell out of the right end of R into the
                        \ C flag, then jump to loin28 to rotate it into the left
                        \ end and move right by a character block

.loin23

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin22             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin22 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin23 using a BCC, or we passed through a
                        \ BCS to get to loin23, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on
 SBC #31                \ the row above (as there are 32 tiles on each row)
 STA SC2
 BCS loin24
 DEC SC2+1

                        \ Fall through into loin24 to fetch the correct tile
                        \ number for the new character block and continue
                        \ drawing

.loin24

                        \ This is the entry point for this part (we jump here
                        \ from part 5 when the line is steep and X1 <= X2)
                        \
                        \ We jump here with X containing the y-axis counter,
                        \ i.e. the number of steps we need to take along the
                        \ y-axis when drawing the line

 STX Q                  \ Store the updated y-axis counter in Q

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixel that we want to draw, then a
 BNE loin25             \ pattern has already been allocated to this entry, so
                        \ skip the following

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ loin29             \ patterns to use for drawing lines and pixels, so jump
                        \ to loin29 to move on to the next pixel in the line

 STA (SC2,X)            \ Otherwise firstFreePattern contains the number of the
                        \ next available pattern for drawing, so allocate this
                        \ pattern to cover the pixel that we want to draw by
                        \ setting the nametable entry to the pattern number we
                        \ just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be added to
                        \ the nametable the next time we need to draw lines or
                        \ pixels into a pattern

 JMP loin21             \ Jump to loin21 to calculate the pattern buffer address
                        \ for the new tile and continue drawing

.loin25

                        \ If we get here then we are drawing our line in a
                        \ pattern that was already in the nametable, so it might
                        \ contain pre-existing content

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

 LDX Q                  \ Set X to the value of the x-axis counter

.loin26

                        \ We now loop along the line from left to right, using P
                        \ as a decreasing counter, and at each count we plot a
                        \ single pixel using the pixel mask in R

 LDA R                  \ Fetch the pixel byte from R

 ORA (SC),Y             \ Store R into screen memory at SC(1 0), using OR logic
 STA (SC),Y             \ so it merges with whatever is already on-screen

 DEX                    \ Decrement the y-coordinate counter in X

 BEQ loin20             \ If we have just reached the end of the line along the
                        \ y-axis, jump to loin20 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin27             \ If the addition didn't overflow, jump to loin27 to
                        \ skip the following

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin28             \ If the pixel fell out of the right end of R into the
                        \ C flag, then jump to loin28 to rotate it into the left
                        \ end and move right by a character block

.loin27

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin26             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin26 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin27 using a BCC, or we passed through a
                        \ BCS to get to loin27, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on
 SBC #31                \ the row above (as there are 32 tiles on each row) and
 STA SC2                \ jump to loin24 to fetch the correct tile number for
 BCS loin24             \ the new character block and continue drawing (this
 DEC SC2+1              \ BNE is effectively a JMP as the high byte of SC2(1 0)
 BNE loin24             \ will never be zero (the nametable buffers start at
                        \ address &7000, so the high byte is at least &70)

.loin28

                        \ If we get here, then we just shifted the pixel out of
                        \ the right end of R, so we now need to put it back into
                        \ the left end of R and move to the right by one
                        \ character block

 ROR R                  \ We only reach here via a BCS, so this rotates a 1 into
                        \ the left end of R and clears the C flag

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin24             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin24 to
                        \ draw the next pixel

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on
 SBC #31                \ the row above (as there are 32 tiles on each row) and
 STA SC2                \ jump to loin24 to fetch the correct tile number for
 BCS loin24             \ the new character block and continue drawing
 DEC SC2+1
 JMP loin24

.loin29

                        \ If we get here then we have run out of tiles to
                        \ allocate to the line drawing, so we continue with the
                        \ same calculations, but don't actually draw anything in
                        \ this character block

 LDX Q                  \ Set X to the value of the x-axis counter

.loin30

 DEX                    \ Decrement the x-axis counter in X

 BEQ loin32             \ If we have just reached the end of the line along the
                        \ x-axis, jump to loin32 to return from the subroutine

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC loin31             \ If the addition didn't overflow, jump to loin31 to
                        \ skip the following

 LSR R                  \ Shift the single pixel in R to the right to step along
                        \ the x-axis, so the next pixel we plot will be at the
                        \ next x-coordinate along

 BCS loin28             \ If the pixel fell out of the right end of R into the
                        \ C flag, then jump to loin28 to rotate it into the left
                        \ end and move right by a character block

.loin31

 DEY                    \ Decrement Y to point to move to the pixel line above

 BPL loin30             \ If Y is still positive then we have not yet gone past
                        \ the top of the character block, so jump to loin30 to
                        \ draw the next pixel

                        \ Otherwise we just gone past the top of the current
                        \ character block, so we need to move up into the
                        \ character block above by setting Y and SC2(1 0)

 LDY #7                 \ Set Y to point to the bottom pixel row of the block
                        \ above

                        \ If we get here then the C flag is clear, as we either
                        \ jumped to loin31 using a BCC, or we passed through a
                        \ BCS to get to loin31, so the SBC #31 below actually
                        \ subtracts 32

 LDA SC2                \ Subtract 32 from SC2(1 0) to get the tile number on
 SBC #31                \ the row above (as there are 32 tiles on each row)
 STA SC2
 BCS P%+4
 DEC SC2+1

 JMP loin24             \ Jump to loin24 to fetch the correct tile number for
                        \ the new character block and continue drawing

.loin32

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 CLC                    \ Clear the C flag for the routine to return

 RTS                    \ Return from the subroutine

