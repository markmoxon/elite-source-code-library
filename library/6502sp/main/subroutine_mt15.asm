\ ******************************************************************************
\
\       Name: MT15
\       Type: Subroutine
\   Category: Text
\    Summary: Set DTW4 and DTW5 to 0
\
\ ******************************************************************************

.MT15

 LDA #0                 \ Set DTW4 = 0
 STA DTW4

 ASL A                  \ Set DTW5 = 0 (even when we fall through from MT14 with
 STA DTW5               \ A set to %10000000)

 RTS                    \ Return from the subroutine

