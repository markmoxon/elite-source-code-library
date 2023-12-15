\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the bottom three text rows of the mode 1 screen by sending a
\             #clyns command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 0
\
\   Y                   Y is set to 0
\
\ Other entry points:
\
\   SC5                 Contains an RTS
\
\ ******************************************************************************

.CLYNS

 LDA #%11111111         \ Set DTW2 = %11111111 to denote that we are not
 STA DTW2               \ currently printing a word

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

 LDA #21                \ Move the text cursor to column 1, row 21
 STA YC
 LDA #1
 STA XC

 LDA #clyns             \ Send a #clyns command to the I/O processor to clear
 JSR OSWRCH             \ the bottom three text rows of the top part of the
 JSR OSWRCH             \ screen

 LDA #0                 \ Set A = 0

 TAY                    \ Set Y = 0

.SC5

 RTS                    \ Return from the subroutine

