\ ******************************************************************************
\
\       Name: Main game loop for flight (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Update the main loop counters
\
\ ******************************************************************************

.TT100_FLIGHT

 JSR M%                 \ Call M% to iterate through the main flight loop

 DEC DLY                \ Decrement the delay counter in DLY, so any in-flight
                        \ messages get removed once the counter reaches zero

 BEQ me2_flight         \ If DLY is now 0, jump to me2_flight to remove any
                        \ in-flight message from the space view, and once done,
                        \ return to me3_flight below, skipping the following
                        \ two instructions

 BPL me3_flight         \ If DLY is positive, jump to me3_flight to skip the
                        \ next instruction

 INC DLY                \ If we get here, DLY is negative, so we have gone too
                        \ and need to increment DLY back to 0

.me3_flight

 DEC MCNT               \ Decrement the main loop counter in MCNT

 BEQ d_3fd4             \ If the counter has reached zero, which it will do
                        \ every 256 main loops, skip the next JMP instruction
                        \ (or to put it another way, if the counter hasn't
                        \ reached zero, jump down to MLOOP, skipping all the
                        \ following checks)

.ytq_flight

 JMP MLOOP_FLIGHT       \ Jump down to MLOOP_FLIGHT to do some end-of-loop
                        \ tidying and restart the main loop

                        \ We only get here once every 256 iterations of the
                        \ main loop. If we aren't in witchspace and don't
                        \ already have 3 or more asteroids in our local bubble,
                        \ then this section has a 13% chance of spawning
                        \ something benign (the other 87% of the time we jump
                        \ down to consider spawning cops, pirates and bounty
                        \ hunters)
                        \
                        \ If we are in that 13%, then 50% of the time this will
                        \ be a Cobra Mk III trader, and the other 50% of the
                        \ time it will either be an asteroid (98.5% chance) or,
                        \ very rarely, a cargo canister (1.5% chance)

.me2_flight

 LDA MCH                \ Fetch the token number of the current message into A

 JSR MESS               \ Call MESS to print the token, which will remove it
                        \ from the screen as printing uses EOR logic

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

 JMP me3_flight         \ Jump back into the main spawning loop at me3_flight

.d_3fd4

 LDA MJ                 \ If we are in witchspace following a mis-jump, skip the
 BNE ytq_flight         \ following by jumping down to MLOOP_FLIGHT (via
                        \ ytq_flight above)

 JSR DORND              \ Set A and X to random numbers

 CMP #51                \ If A >= 51 (80% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

 LDA JUNK               \ If we already have 3 or more bits of junk in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

 JSR rand_posn          \ Call rand_posn to set up the INWK workspace for a ship
                        \ in a random ship position

 BVS MTT4               \ If V flag is set (50% chance), jump up to MTT4 to
                        \ spawn a trader

 ORA #%01101111         \ Take the random number in A and set bits 0-3 and 5-6,
 STA INWK+29            \ so the result has a 50% chance of being positive or
                        \ negative, and a 50% chance of bits 0-6 being 127.
                        \ Storing this number in the roll counter therefore
                        \ gives our new ship a fast roll speed with a 50%
                        \ chance of having no damping, plus a 50% chance of
                        \ rolling clockwise or anti-clockwise

 LDA SSPR               \ If we are inside the space station safe zone, jump
 BNE MLOOPS             \ down to MLOOPS to skip the following and potentially
                        \ spawn something else

 TXA                    \ Set A to the random X we set above, which we haven't
 BCS MTT2               \ used yet, and if the C flag is set (50% chance) jump
                        \ down to MTT2 to skip the following

 AND #15                \ Set the ship speed to our random number, reduced to
 STA INWK+27            \ the range 0 to 15

 BCC MTT3               \ Jump down to MTT3, skipping the following (this BCC
                        \ is effectively a JMP as we know the C flag is clear,
                        \ having passed through the BCS above)

.MTT2

 ORA #%01111111         \ Set bits 0-6 of A to 127, leaving bit 7 as random, so
 STA INWK+30            \ storing this number in the pitch counter means we have
                        \ full pitch with no damping, with a 50% chance of
                        \ pitching up or down

.MTT3

 JSR DORND              \ Set A and X to random numbers

 CMP #10                \ If random A >= 10 (96% of the time), set the C flag

 AND #1                 \ Reduce A to a random number that's 0 or 1

 ADC #OIL               \ Set A = #OIL + A + C, so there's a tiny chance of us
                        \ spawning a cargo canister (#OIL) and an even chance of
                        \ us spawning either a boulder (#OIL + 1) or an asteroid
                        \ (#OIL + 2)

 BNE horde_plain        \ Jump to horde_plain to spawn a whole pack of cargo
                        \ canisters, boulders or asteroids, according to the
                        \ value of A (the BNE is effectivey a JMP, as A will
                        \ never be zero)

