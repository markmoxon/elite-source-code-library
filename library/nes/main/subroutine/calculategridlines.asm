\ ******************************************************************************
\
\       Name: CalculateGridLines
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Reset the line coordinate tables and populate them with the
\             characters for a specified scroll text
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y X)               The content of the scroll text to display
\
\ Returns:
\
\   INF(1 0)            The content of the scroll text to display
\
\ ******************************************************************************

.CalculateGridLines

 STX INF                \ Set INF(1 0) = (Y X)
 STY INF+1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We start by clearing out the buffer at Y1TB

 LDY #240               \ The buffer contains 240 bytes, so set a byte counter
                        \ in Y

 LDA #0                 \ Set A = 0 so we can zero the buffer

.resg1

 STA Y1TB-1,Y           \ Zero the entry Y - 1 in Y1TB

 DEY                    \ Decrement the byte counter

 BNE resg1              \ Loop back until we have reset the whole Y1TB buffer

                        \ We now populate the grid line buffer with the lines
                        \ for the scroll text at INF(1 0)

 LDX #0                 \ Set XP = 0, so the scroll text starts at x-coordinate
 STX XP                 \ 0, on the left of the screen

 LDA #5*W2Y             \ Set YP so the scroll text starts five lines of scroll
 STA YP                 \ text down the screen (as W2Y is the height of each
                        \ line in scroll text coordinates)

 LDY #0                 \ Set XC = 0, so we start from the first character of
 STY XC                 \ INF(1 0)

 LDA #4                 \ Set LASCT = 4, so we process four lines of text in the
 STA LASCT              \ following loop

.resg2

 JSR GRIDSET+5          \ Populate the line coordinate tables with the pixel
                        \ lines for one 21-character line of scroll text,
                        \ drawing the line at (0, YP)

 LDA YP                 \ Set YP = YP - W2Y
 SEC                    \
 SBC #W2Y               \ So YP moves down the screen by one line (as W2Y is the
 STA YP                 \ height of each line in scroll text coordinates)

 DEC LASCT              \ Decrement the loop counter in LASCT

 BNE resg2              \ Loop back until we have processed LASCT lines of
                        \ scroll text

 RTS                    \ Return from the subroutine

