\ ******************************************************************************
\
\       Name: rand_posn
\       Type: Subroutine
\   Category: Universe
\    Summary: Set up the INWK workspace for a ship in a random ship position
\
\ ------------------------------------------------------------------------------
\
\ This routine sets up a new ship, with the following coordinates:
\
\   * (x_sign x_hi x_lo) is a random number in the range -8191 to +8191:
\
\     * x_sign is randomly positive or negative
\     * x_hi is a random number in the range 0 to 31
\     * x_lo is a random number in the range 0 to 255
\
\   * (y_sign y_hi y_lo) is a random number in the range -8191 to +8191:
\
\     * y_sign is randomly positive or negative
\     * y_hi is a random number in the range 0 to 31
\     * y_lo is a random number in the range 0 to 255
\
\   * z_sign is a random number in the range 4352 to 20224:
\
\     * z_sign is 0 (positive)
\     * z_hi is a random number in the range 17 to 79
\     * z_lo is 0
\
\ In other words, the ship is randomly up, down, left or right, but is always in
\ front of us.
\
\ Returns:
\
\   A                   A is set to a random number
\
\   X                   X is set to a random number
\
\   T1                  T1 is set to a random number
\
\ ******************************************************************************

.rand_posn

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR DORND              \ Set A and X to random numbers

 STA INWK               \ Set x_lo to the random number in A

 STX INWK+3             \ Set y_lo to the random number in X

 STA T1                 \ Store x_lo in T1

 LSR A                  \ Set bit 7 of x_sign randomly (to bit 0 of the random
 ROR INWK+2             \ number in A), so the x-coordinate it is randomly
                        \ positive or negative

 LSR A                  \ Set bit 7 of y_sign randomly (to bit 1 of the random
 ROR INWK+5             \ number in A), so the y-coordinate it is randomly
                        \ positive or negative

 LSR A                  \ Set bits 0-4 of y_hi randomly (to bits 3-7 of the
 STA INWK+4             \ random number in A), so the high byte of the
                        \ y-coordinate is in the range 0 to 31

 TXA                    \ Set x_hi to the random number X, reduced to the range
 AND #31                \ 0 to 31
 STA INWK+1

 LDA #80                \ Set z_hi = 80 - x_hi - y_hi - 1
 SBC INWK+1             \
 SBC INWK+4             \ The C flag is clear as INWK+4 was 0 before the ROR
 STA INWK+7             \ above, so this sets z_hi in the range 17 to 79
                        \ (as x_hi and y_hi are both in the range 0 to 31)

 JMP DORND              \ Set A and X to random numbers and return from the
                        \ subroutine using a tail call

