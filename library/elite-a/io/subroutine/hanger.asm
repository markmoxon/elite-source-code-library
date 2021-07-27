\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Implement the picture_h command (draw horizontal lines for the
\             ship hanger floor)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a picture_h command. It draws a
\ specified number of horizontal lines for the ship hanger's floor, making sure
\ it draws between the ships when there are multiple ships in the hanger.
\
\ ******************************************************************************

.HANGER

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA picture_1          \
 JSR tube_get           \   picture_h(line_count, multiple_ships)
 STA picture_2          \
                        \ and store them as follows:
                        \
                        \   * picture_1 = the number of horizontal lines to draw
                        \
                        \   * picture_2 = 0 if there is only one ship, non-zero
                        \                 otherwise

 LDA picture_1          \ Set Y = #Y + picture_1
 CLC                    \
 ADC #Y                 \ where #Y is the y-coordinate of the centre of the
                        \ screen, so Y is now the horizontal pixel row of the
                        \ line we want to draw to display the hanger floor

 LSR A                  \ Set A = A >> 3
 LSR A
 LSR A

 ORA #&60               \ Each character row in Elite's screen mode takes up one
                        \ page in memory (256 bytes), so we now OR with &60 to
                        \ get the page containing the line

 STA SC+1               \ Store the screen page in the high byte of SC(1 0)

 LDA picture_1          \ Set the low byte of SC(1 0) to the y-coordinate mod 7,
 AND #7                 \ which determines the pixel row in the character block
 STA SC                 \ we need to draw in (as each character row is 8 pixels
                        \ high), so SC(1 0) now points to the address of the
                        \ start of the horizontal line we want to draw

 LDY #0                 \ Set Y = 0 so the call to HAS2 starts drawing the line
                        \ in the first byte of the screen row, at the left edge
                        \ of the screen

 JSR HAS2               \ Draw a horizontal line from the left edge of the
                        \ screen, going right until we bump into something
                        \ already on-screen, at which point stop drawing

 LDA #%00000100         \ Now to draw the same line but from the right edge of
                        \ the screen, so set a pixel mask in A to check the
                        \ sixth pixel of the last byte, so we skip the 2-pixel
                        \ scren border at the right edge of the screen

 LDY #248               \ Set Y = 248 so the call to HAS3 starts drawing the
                        \ line in the last byte of the screen row, at the right
                        \ edge of the screen

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

 LDY picture_2          \ Fetch the value of picture_2, which is 0 if there is
                        \ only one ship

 BEQ l_2045             \ If picture_2 is zero, jump to l_2045 to return from
                        \ the subroutine as there is only one ship in the
                        \ hanger, so we are done

 JSR HAS2               \ Call HAS2 to a line to the right, starting with the
                        \ third pixel of the pixel row at screen address SC(1 0)

 LDY #128               \ We now draw the line from the centre of the screen
                        \ to the left. SC(1 0) points to the start address of
                        \ the screen row, so we set Y to 128 so the call to
                        \ HAS3 starts drawing from halfway along the row (i.e.
                        \ from the centre of the screen)

 LDA #%01000000         \ We want to start drawing from the second pixel, to
                        \ avoid the border, so we set a pixel mask accordingly

 JSR HAS3               \ Call HAS3, which draws a line from the halfway point
                        \ across the left half of the screen, going left until
                        \ we bump into something already on-screen, at which
                        \ point it stops drawing

.l_2045

 RTS                    \ Return from the subroutine

