\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the bottom three text rows of the mode 4 screen by sending a
\             clr_line command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 0
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.CLYNS

 LDA #%11111111         \ Set DTW2 = %11111111 to denote that we are not
 STA DTW2               \ currently printing a word

 LDA #20                \ Move the text cursor to row 20, near the bottom of
 STA YC                 \ the screen

 JSR TT67               \ Print a newline, which will move the text cursor down
                        \ a line (to row 21) and back to column 1

 LDY #1                 \ Move the text cursor to column 1
 STY XC

 DEY                    \ Set Y = 0, so the subroutine returns with this value

 LDA #&84               \ Send command &84 to the I/O processor:
 JMP tube_write         \
                        \   clr_line()
                        \
                        \ which will clear the bottom three text rows of the top
                        \ part of the screen and return from the subroutine
                        \ using a tail call

