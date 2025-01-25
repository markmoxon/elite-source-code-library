\ ******************************************************************************
\
\       Name: DIALS (Part 2 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: pitch and roll indicators
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA #WHITE             \ Set COL to white to use as the colour for the pitch
 STA COL                \ and roll indicators

 LDA ALP1               \ Fetch the roll angle alpha as a value between 0 and
 LSR A                  \ 31, and divide by 2 to get a value of 0 to 15

 BIT ALP2+1             \ Set the N flag according to the opposite sign of the
                        \ roll angle, which is stored in ALP2+1

 JSR DIS5               \ Call DIS5 with Y = 1 to draw the roll indicator using
                        \ a range of 0-15, and increment Y to 2 to point to the
                        \ next indicator (the pitch indicator)

 LDA BET1               \ Fetch the magnitude of the pitch angle beta as a
 ASL A                  \ positive value between 0 and 8, and multiply by 2 to
                        \ get a value of 0 to 16

 BIT BET2               \ Set the N flag according to the sign of the pitch
                        \ angle, which is stored in BET2

 JSR DIS5               \ Call DIS5 with Y = 2 to draw the pitch indicator using
                        \ a range of 0-15, and increment Y to 3 to point to the
                        \ next indicator (the bottom of the four energy banks)

