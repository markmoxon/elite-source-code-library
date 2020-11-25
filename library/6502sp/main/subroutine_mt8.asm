\ ******************************************************************************
\
\       Name: MT8
\       Type: Subroutine
\   Category: Text
\    Summary: Tab to column 6 and set all bits on DTW2
\
\ ******************************************************************************

.MT8

 LDA #6                 \ Move the text cursor to column 6
 JSR DOXC

 LDA #%11111111         \ Set all the bits in DTW2
 STA DTW2

 RTS                    \ Return from the subroutine

