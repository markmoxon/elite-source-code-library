\ ******************************************************************************
\
\       Name: HA2
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Implement the picture_v command (draw vertical lines for the ship
\             hanger background)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a picture_v command. It draws the
\ specified number of vertical lines for the ship hanger's background.
\
\ ******************************************************************************

.HA2

 JSR tube_get           \ Get the parameter from the parasite for the command:
                        \
                        \   picture_v(line_count)
                        \
                        \ and store it as follows:
                        \
                        \   * A = the number of vertical lines to draw

 AND #%11111000         \ Each character block contains 8 pixel rows, so to get
                        \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 STA SC                 \ Set the low byte of SC(1 0) to this value

 LDX #&60               \ Set the high byte of SC(1 0) to &60, the high byte of
 STX SC+1               \ the start of screen, so SC(1 0) now points to the
                        \ address where the line starts

 LDX #%10000000         \ Set a mask in X to the first pixel the 8-pixel byte

 LDY #1                 \ We are going to start drawing the line from the second
                        \ pixel from the top (to avoid drawing on the 1-pixel
                        \ border), so set Y to 1 to point to the second row in
                        \ the first character block

.HAL7

 TXA                    \ Copy the pixel mask to A

 AND (SC),Y             \ If the pixel we want to draw is non-zero (using A as a
 BNE HA6                \ mask), then this means it already contains something,
                        \ so jump to HA6 to stop drawing this line

 TXA                    \ Copy the pixel mask to A again

 ORA (SC),Y             \ OR the byte with the current contents of screen
                        \ memory, so the pixel we want is set

 STA (SC),Y             \ Store the updated pixel in screen memory

 INY                    \ Increment Y to point to the next row in the character
                        \ block, i.e. the next pixel down

 CPY #8                 \ Loop back to HAL7 to draw this next pixel until we
 BNE HAL7               \ have drawn all 8 in the character block

 INC SC+1               \ Point SC(1 0) to the next page in memory, i.e. the
                        \ next character row

 LDY #0                 \ Set Y = 0 to point to the first row in this character
                        \ block

 BEQ HAL7               \ Loop back up to HAL7 to keep drawing the line (this
                        \ BEQ is effectively a JMP as Y is always zero)

.HA6

 RTS                    \ Return from the subroutine

