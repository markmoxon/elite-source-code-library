\ ******************************************************************************
\
\       Name: LL9 (Part 2 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Check if ship is in field of view, close enough to draw
\
\ ------------------------------------------------------------------------------
\
\ This part checks whether the ship is in our field of view, and whether it is
\ close enough to be fully drawn (if not, we jump to SHPPT to draw it as a dot).
\
\ ******************************************************************************

.LL10

 LDA XX1+7              \ Set A = z_hi

 CMP #192               \ If A >= 192 then the ship is a long way away, so jump
 BCS LL14               \ to LL14 to remove the ship from the screen

 LDA XX1                \ If x_lo >= z_lo, set the C flag, otherwise clear it
 CMP XX1+6

 LDA XX1+1              \ Set A = x_hi - z_hi using the carry from the low
 SBC XX1+7              \ bytes, which sets the C flag as if we had done a full
                        \ two-byte subtraction (x_hi x_lo) - (z_hi z_lo)

 BCS LL14               \ If the C flag is set then x >= z, so the ship is
                        \ further to the side than it is in front of us, so it's
                        \ outside our viewing angle of 45 degrees, and we jump
                        \ to LL14 to remove it from the screen

 LDA XX1+3              \ If y_lo >= z_lo, set the C flag, otherwise clear it
 CMP XX1+6

 LDA XX1+4              \ Set A = y_hi - z_hi using the carry from the low
 SBC XX1+7              \ bytes, which sets the C flag as if we had done a full
                        \ two-byte subtraction (y_hi y_lo) - (z_hi z_lo)

 BCS LL14               \ If the C flag is set then y >= z, so the ship is
                        \ further above us than it is in front of us, so it's
                        \ outside our viewing angle of 45 degrees, and we jump
                        \ to LL14 to remove it from the screen

 LDY #6                 \ Fetch byte #6 from the ship's blueprint into X, which
 LDA (XX0),Y            \ is the number * 4 of the vertex used for the ship's
 TAX                    \ laser

 LDA #255               \ Set bytes X and X+1 of the XX3 heap to 255. We're
 STA XX3,X              \ going to use XX3 to store the screen coordinates of
 STA XX3+1,X            \ all the visible vertices of this ship, so setting the
                        \ laser vertex to 255 means that if we don't update this
                        \ vertex with its screen coordinates in parts 6 and 7,
                        \ this vertex's entry in the XX3 heap will still be 255,
                        \ which we can check in part 9 to see if the laser
                        \ vertex is visible (and therefore whether we should
                        \ draw laser lines if the ship is firing on us)

 LDA XX1+6              \ Set (A T) = (z_hi z_lo)
 STA T
 LDA XX1+7

 LSR A                  \ Set (A T) = (A T) / 8
 ROR T
 LSR A
 ROR T
 LSR A
 ROR T

 LSR A                  \ If A >> 4 is non-zero, i.e. z_hi >= 16, jump to LL13
 BNE LL13               \ as the ship is possibly far away enough to be shown as
                        \ a dot

 LDA T                  \ Otherwise the C flag contains the previous bit 0 of A,
 ROR A                  \ which could have been set, so rotate A right four
 LSR A                  \ times so it's in the form %000xxxxx, i.e. z_hi reduced
 LSR A                  \ to a maximum value of 31
 LSR A

 STA XX4                \ Store A in XX4, which is now the distance of the ship
                        \ we can use for visibility testing

 BPL LL17               \ Jump down to LL17 (this BPL is effectively a JMP as we
                        \ know bit 7 of A is definitely clear)

.LL13

                        \ If we get here then the ship is possibly far enough
                        \ away to be shown as a dot

 LDY #13                \ Fetch byte #13 from the ship's blueprint, which gives
 LDA (XX0),Y            \ the ship's visibility distance, beyond which we show
                        \ the ship as a dot

 CMP XX1+7              \ If z_hi <= the visibility distance, skip to LL17 to
 BCS LL17               \ draw the ship fully, rather than as a dot, as it is
                        \ closer than the visibility distance

 LDA #%00100000         \ If bit 5 of the ship's byte #31 is set, then the
 AND XX1+31             \ ship is currently exploding, so skip to LL17 to draw
 BNE LL17               \ the ship's explosion cloud

 JMP SHPPT              \ Otherwise jump to SHPPT to draw the ship as a dot,
                        \ returning from the subroutine using a tail call

