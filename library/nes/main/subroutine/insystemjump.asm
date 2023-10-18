\ ******************************************************************************
\
\       Name: InSystemJump
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform an in-system (fast-forward) jump
\
\ ------------------------------------------------------------------------------
\
\ This routine performs an in-system jump by subtracting 64 from z_hi for the
\ planet and sun, and removing all other ships from the bubble. This is the same
\ as our ship moving forwards in space by z_hi = 64, and leaving all the other
\ ships behind.
\
\ ******************************************************************************

.InSystemJump

 LDY #32                \ We start by charging the shields and energy banks 32
                        \ times, so set a loop counter in Y

.jump1

 JSR ChargeShields      \ Charge the shields and energy banks

 DEY                    \ Decrement the loop counter

 BNE jump1              \ Loop back to charge the shields until we have done it
                        \ 32 times

                        \ We now move the sun and planet backwards in space and
                        \ remove everything else from the ship slots, to make it
                        \ appear as if we have jumped forward, leaving
                        \ everything else behind

 LDX #0                 \ We are about to loop through the ship slots, moving
                        \ everything backwards so we appear to jump forwards in
                        \ space, so set X = 0 to use as the slot number

 STX GNTMP              \ Set GNTMP = 0 to cool the lasers down completely

.jump2

 STX XSAV               \ Store the slot number in XSAV so we can retrieve it
                        \ below

 LDA FRIN,X             \ Load the ship type for the X-th slot

 BEQ jump4              \ If the slot contains 0 then it is empty and we have
                        \ processed all the slots (as they are always shuffled
                        \ down in the main loop to close up and gaps), so jump
                        \ to jump4 as we are done

 BMI jump3              \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet or the sun, so jump down to
                        \ jump3 to move the planet or sun in space

                        \ If we get here then this is not the planet or sun, so
                        \ we now remove this ship from our local bubble of
                        \ universe

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

 JSR RemoveShip         \ Fetch the ship's data block and remove the ship from
                        \ our local bubble of universe

 LDX XSAV               \ Set X to the slot counter that we stored in XSAV above

 JMP jump2              \ Loop back to process the next slot

.jump3

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

 LDA #&80               \ Set (S R) = -64
 STA S                  \
 LSR A                  \ This is a sign-magnitude number, with bit 7 of S set
 STA R                  \ and R = 128 / 2 = 64

 LDY #7                 \ Set P = z_hi from the ship's data block
 LDA (INF),Y
 STA P

 INY                    \ Set A = z_sign from the ship's data block
 LDA (INF),Y

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = (z_sign z_hi) - 64

 STA (INF),Y            \ Store the result in (z_sign z_hi) in the ship's data
 DEY                    \ block, so the object moves backwards by a distance of
 TXA                    \ z_hi = 64 (which is the distance of an in-system jump)
 STA (INF),Y

 LDX XSAV               \ Set X to the slot counter that we stored in XSAV above

 INX                    \ Increment X to point to the next ship slot

 BNE jump2              \ Loop back to process the next slot (this BNE is
                        \ effectively a JMP as we will exit the above loop well
                        \ before X wraps around to 0

.jump4

 RTS                    \ Return from the subroutine

