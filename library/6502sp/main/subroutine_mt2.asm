\ ******************************************************************************
\
\       Name: MT2
\       Type: Subroutine
\   Category: Text
\    Summary: Set bit 5 of DTW1 and clear all bits of DTW6
\
\ ******************************************************************************

.MT2

 LDA #%00100000         \ Set bit 5 of DTW1
 STA DTW1

 LDA #0                 \ Clear bit 7 of DTW6
 STA DTW6

 RTS                    \ Return from the subroutine

