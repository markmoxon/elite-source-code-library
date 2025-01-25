\ ******************************************************************************
\
\       Name: DIALS (Part 3 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: four energy banks
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA ENERGY             \ Set A = ENERGY / 2, so it is in the range 0-127 (so
 LSR A                  \ that's a maximum of 32 in each of the banks, and a
                        \ maximum of 31 in the top bank)

.DIL1

 STA K+1                \ Store A in K+1 so we can retrieve it after the call
                        \ to DIS2

 JSR DIS2               \ Draw the energy bank specified in Y using a range of
                        \ 0-31, and increment Y to point to the next indicator
                        \ (the next energy bank up)

 LDA K+1                \ Restore A from K+1, so it once again contains the
                        \ remaining energy as we work our way through each bank,
                        \ from the full ones at the bottom to the empty ones at
                        \ the top

 SEC                    \ Set A = A - 32 to reduce the energy count by a full
 SBC #32                \ bank

 BCS P%+4               \ If the subtraction didn't underflow then we still have
                        \ some energy to draw in the banks above, so skip the
                        \ following instruction

 LDA #0                 \ We have now drawn all the energy in the energy banks,
                        \ so set A = 0 so we draw empty energy bars for the rest
                        \ of the banks, working upwards

 CPY #7                 \ Loop back until we have drawn all four energy banks
 BNE DIL1               \ (for Y = 3, 4, 5, 6)

