\ ******************************************************************************
\
\       Name: MT29
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to row 6, white text, set bit 7 of DTW6 and
\             bit 5 of DTW1
\
\ ******************************************************************************

.MT29

 LDA #6                 \ Move the text cursor to row 6
 JSR DOYC

 JSR WHITETEXT          \ Set white text ????

 JMP MT13               \ Jump to MT13 to set bit 7 of DTW6 and bit 5 of DTW1,
                        \ returning from the subroutine using a tail call

