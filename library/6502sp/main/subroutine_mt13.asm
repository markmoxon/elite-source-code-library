\ ******************************************************************************
\
\       Name: MT13
\       Type: Subroutine
\   Category: Text
\    Summary: Set bit 7 of DTW6 and bit 5 of DTW1
\
\ ******************************************************************************

.MT13

 LDA #%10000000         \ Set bit 7 of DTW6
 STA DTW6

 LDA #%00100000         \ Set bit 5 of DTW1
 STA DTW1

 RTS                    \ Return from the subroutine

