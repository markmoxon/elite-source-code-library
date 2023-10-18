\ ******************************************************************************
\
\       Name: CHPR (Part 6 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character in the space view when the relevant font is not
\             loaded, merging the text with whatever is already on-screen
\
\ ******************************************************************************

.chpr27

                        \ We jump here from below when the tile we are drawing
                        \ into is not empty

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0), using OR logic to merge the character with
                        \ the existing contents of the tile

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr28

                        \ If we get here then this is the space view with no
                        \ font loaded, and we have set up P(2 1) to point to the
                        \ pattern data for the character we want to draw

 LDA #0                 \ Set SC+1 = 0 to act as the high byte of SC(1 0) in the
 STA SC+1               \ calculation below

 LDA YC                 \ Set A to the current text cursor row

 BNE chpr29             \ If the cursor is in row 0, set A = 255 so the value
 LDA #255               \ of A + 1 is 0 in the calculation below

.chpr29

 CLC                    \ Set (SC+1 A) = (A + 1) * 16
 ADC #1
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1

 SEC                    \ Set SC(1 0) = (nameBufferHi 0) + (SC+1 A) * 2 + 1
 ROL A                  \             = (nameBufferHi 0) + (A + 1) * 32 + 1
 STA SC                 \
 LDA SC+1               \ So SC(1 0) points to the entry in the nametable buffer
 ROL A                  \ for the start of the row below the text cursor, plus 1
 ADC nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor, minus one
 DEY

                        \ So SC(1 0) + Y now points to the nametable entry of
                        \ the tile where we want to draw our character

 LDA (SC),Y             \ If the nametable entry for the tile is not empty, then
 BNE chpr27             \ jump up to chpr27 to draw our character into the
                        \ existing pattern for this tile

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ chpr30             \ to use for drawing characters, so jump to chpr17 via
                        \ chpr30 to return from the subroutine without printing
                        \ anything

 STA (SC),Y             \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this
                        \ tile to cover the character that we want to draw by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0)


.chpr30

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr31

                        \ If we get here then this is the space view and the
                        \ text cursor is on row 0

 LDA #33                \ Set SC(1 0) to the address of tile 33 in the nametable
 STA SC                 \ buffer, which is the first tile on row 1
 LDA nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 JMP chpr15             \ Jump up to chpr15 to continue drawing the character

