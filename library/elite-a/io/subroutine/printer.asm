\ ******************************************************************************
\
\       Name: printer
\       Type: Subroutine
\   Category: Text
\    Summary: Send the screen to the printer, following a CTRL-P key press
\
\ ------------------------------------------------------------------------------
\
\ In the following, the escape sequences sent to the printer are standard Epson
\ printer codes.
\
\ ******************************************************************************

.printer

 LDA #2                 \ Print ASCII 2 using the VDU routine in the MOS, which
 JSR print_safe         \ means "start sending characters to the printer"

 LDA #'@'               \ Send "ESC @" to the printer to initialise the printer
 JSR print_esc

 LDA #'A'               \ Send "ESC A 8" to the printer to select line spacing
 JSR print_esc          \ of 8/72 inches (1/9")
 LDA #8
 JSR print_wrch

 LDA #&60               \ Set SC(1 0) = &6000, so it points to the start of
 STA SC+1               \ screen memory
 LDA #0
 STA SC

.print_view

 LDA #'K'               \ Send "ESC K 0 1" to the printer to select single
 JSR print_esc          \ density graphics (60 dpi)
 LDA #0
 JSR print_wrch
 LDA #1
 JSR print_wrch

                        \ We print the screen one character block at a time
                        \ (where each character block is made up of 8 rows,
                        \ with each row being one byte of screen memory)
                        \
                        \ We do this in three parts. First, we extract the
                        \ screen memory for the character block and stick it
                        \ into a buffer at print_bits. Second, if this is the
                        \ dashboard, which is in colour, then we process the
                        \ contents of the buffer into pixel patterns (as the
                        \ printer can only print monochrome dots). Finally, we
                        \ send the character block to the printer as a sequence
                        \ of one-pixel wide vertical slices of eight pixels in
                        \ height, working our way from left to right until the
                        \ character block is printed. And then we move onto the
                        \ next character block until the whole screen is printed

.print_outer

 LDY #7                 \ We want to print a single character block of screen
                        \ memory, so set a counter in Y for the 8 rows in the
                        \ character block

 LDX #&FF               \ Set X as an index into the print_bits buffer, starting
                        \ at &FF so the initial INX increments it to an index of
                        \ 0 for the first entry in the buffer

.print_copy

 INX                    \ Increment the pointer into the print_bits buffer, so
                        \ we can store the character rows in the buffer,
                        \ starting with the bottom row of the character and
                        \ working our way to the top

 LDA (SC),Y             \ Grab the Y-th row from the character block and store
 STA print_bits,X       \ it in the X-th byte of print_bits

 DEY                    \ Decrement the character row counter

 BPL print_copy         \ Loop back to print_copy until we have copied all eight
                        \ rows of the character block into the buffer

 LDA SC+1               \ If the high byte in SC(1 0) < &78 then we are still
 CMP #&78               \ printing the space view, so jump down to print_inner
 BCC print_inner

                        \ Otherwise we are printing the dashboard, so we now
                        \ need to process the data in the buffer to use pixel
                        \ patterns, as the structure of each mode 5 screen
                        \ memory byte is interleaved so that the first pixel is
                        \ in bits 0 and 4, the second is in bits 1 and 5, and
                        \ so on
                        \
                        \ The idea is that we convert each interleaved pixel
                        \ pair into a two-dot wide pixel, so the colour screen
                        \ gets translated into monochrome pixels that match the
                        \ screen layout

                        \ Note that at this point, X is 7, so we can use it as
                        \ an index into the print_bits buffer as we work our way
                        \ through each byte

.print_radar

 LDY #7                 \ For each character pixel row we loop through each bit
                        \ in the interleaved byte, so set a counter in Y for 8
                        \ bits

 LDA #0                 \ We build up the new pixel row in A, so start with 0
                        \ so we can fill it up with the correct bit pattern

                        \ The following loop works through each bit in the X-th
                        \ pixel row byte, converting it to a monochrome pattern
                        \ that we can print, which gets stored in the print_bits
                        \ buffer in place of the original colour byte

.print_split

 ASL print_bits,X       \ Shift the pixel row byte to the left, so the leftmost
                        \ bit falls off the end and into the C flag

 BCC print_merge        \ If that bit is clear, jump to print_merge to skip the
                        \ following instruction and move onto the next bit

 ORA print_tone,Y       \ The Y-th bit in the original colour byte was set, so
                        \ we grab the Y-th entry from print_tone and OR it into
                        \ the new pixel row byte in A. If you look at the pixel
                        \ rows in the print_tone table, you can see that:
                        \
                        \   * If Y is 0 or 4, we set monochrome pixels 0 and 1
                        \   * If Y is 1 or 5, we set monochrome pixels 2 and 3
                        \   * If Y is 2 or 6, we set monochrome pixels 4 and 5
                        \   * If Y is 3 or 7, we set monochrome pixels 6 and 7
                        \
                        \ The above equates to:
                        \
                        \   * If colour pixel 0 is non-zero, we set monochrome
                        \     pixels 0 and 1
                        \
                        \   * If colour pixel 1 is non-zero, we set monochrome
                        \     pixels 2 and 3
                        \
                        \   * If colour pixel 2 is non-zero, we set monochrome
                        \     pixels 4 and 5
                        \
                        \   * If colour pixel 3 is non-zero, we set monochrome
                        \     pixels 6 and 7
                        \
                        \ So this takes a four-pixel wide character row, and
                        \ creates an eight-pixel wide character row made up of
                        \ two-pixel wide blocks that match the original pattern,
                        \ which is what we want for our printer-friendly version
                        \ of the mode 5 colour dashboard

.print_merge

 DEY                    \ Decrement the bit counter in Y to move onto the next
                        \ bit in the pixel row byte

 BPL print_split        \ Loop back to print_split until we have shifted all
                        \ eight bits, at which point we have our new monochrome
                        \ pixel row byte

 STA print_bits,X       \ Store the new pixel row byte in A into the X-th entry
                        \ in the print_bits buffer, replacing the unprintable
                        \ colour byte that was there before

 DEX                    \ Decrement the pointer into the print_bits buffer

 BPL print_radar        \ Loop back to process the next entry in the print_bits
                        \ buffer until we have processed all eight rows in the
                        \ character block

                        \ We now want to print the character block that we
                        \ stored in the print_bits buffer, which we do by
                        \ printing one-pixel wide vertical slices of the
                        \ character, starting from the left edge of the block
                        \ and working our way to the right edge of the block

.print_inner

 LDY #7                 \ We want to work our way through the eight columns in
                        \ the character block, so set a counter in Y for this

.print_block

 LDX #7                 \ We want to work our way through the eight rows in
                        \ the character block, so set a counter in X for this,
                        \ starting with the last row as we put the rows into
                        \ the print_bits buffer in reverse order (so this will
                        \ pull them out in the correct order, from top to
                        \ bottom, as we put them into print_bits with the bottom
                        \ row first, so starting with X = 7 will pull out the
                        \ top row first)

.print_slice

 ASL print_bits,X       \ Shift the byte for the X-th row in the character block
                        \ to the left, so the leftmost pixel falls off the end
                        \ and into the C flag

 ROL A                  \ Shift the pixel from the C flag into bit 0 of A, so we
                        \ build up the vertical slice of 8 pixels in A, one
                        \ pixel at a time

 DEX                    \ Decrement the vertical pixel counter

 BPL print_slice        \ Loop back until we have extracted all 8 pixels in the
                        \ vertical slice into A

 JSR print_wrch         \ Send the one-pixel vertical slice to the printer, so
                        \ we print 8 vertical pixels and shift along one pixel

 DEY                    \ Decrement the column counter to move onto the next
                        \ vertical slice in the character block

 BPL print_block        \ Loop back until we have printer 8 vertical slices of
                        \ one-pixel width, at which point we have printed the
                        \ whole character block

.print_next

                        \ We now want to move onto the next character block on
                        \ the row, so we add 8 to the screen address in SC(1 0)
                        \ as there are 8 bytes in each character block

 CLC                    \ Set SC(1 0) = SC(1 0) + 8
 LDA SC                 \
 ADC #8                 \ starting with the low byte in SC
 STA SC

 BNE print_outer        \ If the above addition didn't wrap around back to 0,
                        \ the addition is correct, so loop back up to
                        \ print_outer to print the next character block along

                        \ If we get here then we have just wrapped around to the
                        \ next page in screen memory, which means we have
                        \ reached the end of the current character row and need
                        \ to move onto the next row

 LDA #13                \ Send a carriage return character (ASCII 13) to the
 JSR print_wrch         \ printer to move the printer head down to the next line

 INC SC+1               \ Increment the high byte of SC(1 0) to point the screen
                        \ address to the start of the next character row

 LDX SC+1               \ Set X to the high byte of SC(1 0) plus 1, which points
 INX                    \ to the character row after the one we are about to
                        \ print

 BPL print_view         \ If bit 7 of X is clear, this means that X < &80, so
                        \ the high byte of SC(1 0) < &7F, which means we haven't
                        \ yet reached the end of screen memory at &76FF, so
                        \ loop back to print_view to set the graphics density
                        \ again (as we have to do this on each row) and move
                        \ onto the next character row

 LDA #3                 \ Print ASCII 3 using the VDU routine in the MOS, which
 JMP print_safe         \ means "stop sending characters to the printer", and
                        \ return from the subroutine using a tail call

\JSR print_safe         \ These instructions are commented out in the original
\JMP tube_put           \ source

