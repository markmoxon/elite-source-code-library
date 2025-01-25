\ ******************************************************************************
\
\       Name: TTX66K
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the whole screen or just the space view (as appropriate),
\             and draw a border box if required
\
\ ------------------------------------------------------------------------------
\
\ If this is a high-resolution graphics view, clear the top part of the screen
\ and draw a border box.
\
\ If this is a text view, clear the screen.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BOX                 Just draw the border box along the top of the screen
\                       (the sides are retained from the loading screen, along
\                       with the dashboard)
\
\   cleartext           Clear screen memory for the text screen mode
\
\ ******************************************************************************

.TTX66K

 LDA QQ11               \ If this is the space view, jump to wantgrap to set up
 BEQ wantgrap           \ the high-resolution graphics screen

 CMP #13                \ If QQ11 = 13 then this is either the title screen or
 BEQ wantgrap           \ the rotating ship screen in the mission 1 briefing, so
                        \ jump to wantgrap to set up the high-resolution
                        \ graphics screen

 AND #%11000000         \ If either bit 6 or 7 of the view type is set - so
 BNE wantgrap           \ this is either the Short-range or Long-range Chart -
                        \ then jump to wantgrap to set up the high-resolution
                        \ graphics screen

 JSR cleartext          \ This is a text view, so clear screen memory for the
                        \ text screen mode

 JMP TEXT               \ Switch to the text screen mode, returning from the
                        \ subroutine using a tail call

.cleartext

 LDY #0                 \ Set Y = 0 to use as a byte counter when clearing
                        \ screen memory for the text mode

 LDX #4                 \ Set X = 4 to use as a page counter when clearing the
                        \ four pages of screen memory from &0400 to &0800

 STY SC                 \ Set SC(1 0) = &0400, which is the address of screen
 STX SC+1               \ memory for bank 1 of the text screen mode

 LDA #160               \ Set A to 160, which is the ASCII for a space character
                        \ with bit 7 set, which is a space character in normal
                        \ video
                        \
                        \ We set bit 7 so it will show as a black block on
                        \ screen when we fill the text mode's screen memory with
                        \ this value, as opposed to a white block if it were in
                        \ inverse video

.cleartextl

 STA (SC),Y             \ Blank the Y-th byte of screen memory at SC(1 0)

 INY                    \ Increment the byte counter

 BNE cleartextl         \ Loop back until we have cleared a whole page of text
                        \ mode screen memory

 INC SC+1               \ Increment the high byte of SC(1 0) so it points to
                        \ the next page in screen memory

 DEX                    \ Decrement the page counter

 BNE cleartextl         \ Loop back until we have cleared four pages of memory

 RTS                    \ Return from the subroutine

.wantgrap

 JSR cleargrap          \ This is a high-resolution graphics view, so clear
                        \ screen memory for the top part of the graphics screen
                        \ mode (the space view)

 JSR BOX                \ Call BOX to draw a border box along the top edge of
                        \ the space view (the sides are retained from the
                        \ loading screen, along with the dashboard)

 JSR HGR                \ Switch to the high-resolution graphics screen mode

 RTS                    \ Return from the subroutine

.BOX

 LDX #0                 \ Set X1 = 0
 STX X1

 STX Y1                 \ Set Y1 = 0

 DEX                    \ Set X2 = 255
 STX X2

 LDA #BLUE              \ Switch to colour blue
 STA COL

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1) in
                        \ blue, which will draw a line along the top edge of the
                        \ screen from (0, 0) to (255, 0)

 LDA #%10101010         \ Draw the top-left corner of the box as a continuous
 STA SCBASE+1           \ line of blue

 LDA #%10101010         \ Draw the top-right corner of the box as a continuous
 STA SCBASE+37          \ line of blue

 RTS                    \ Return from the subroutine

