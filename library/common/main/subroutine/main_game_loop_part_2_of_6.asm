\ ******************************************************************************
\
\       Name: Main game loop (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Call the main flight loop, and potentially spawn a trader, an
\             asteroid, or a cargo canister
ELIF _DISC_DOCKED
\    Summary: Potentially spawn a trader, an asteroid, or a cargo canister
\             (though this has no effect when docked)
ELIF _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
\    Summary: Update the main loop counters
ENDIF
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Comment
\ In the docked code, we start the main game loop at part 2 and then jump
\ straight to part 5, as parts 1, 3 and 4 are not required when we are docked.
\
ELIF _ELITE_A_ENCYCLOPEDIA
\ In the encyclopedia code, we start the main game loop at part 2 and then jump
\ straight to part 5, as parts 1, 3 and 4 are not required when we are docked.
\
ENDIF
\ This section covers the following:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * Call M% to do the main flight loop
\
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)
\   * Potentially spawn a trader, asteroid or cargo canister
\
ELIF _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
\   * Update the main loop counters
\
ENDIF
\ Other entry points:
\
\   TT100               The entry point for the start of the main game loop,
\                       which calls the main flight loop and the moves into the
\                       spawning routine
\
IF NOT(_NES_VERSION)
\   me3                 Used by me2 to jump back into the main game loop after
\                       printing an in-flight message
\
ENDIF
\ ******************************************************************************

.TT100

IF _NES_VERSION

 LDA nmiTimerLo         \ Store the low byte of the NMI timer (which will be
 STA RAND               \ pretty random) in the RAND seed

 LDA K%+6               \ Store the z_lo coordinate for the planet (which will
 STA RAND+1             \ be pretty random) in the RAND+1 seed

 LDA soundVibrato       \ Store the soundVibrato variable (which will be pretty
 STA RAND+3             \ random) in the RAND+3 seed

 LDA QQ12               \ Fetch the docked flag from QQ12 into A

 BEQ game2              \ If we are docked, jump down to MLOOP to skip all the
 JMP MLOOP              \ the flight and spawning code in the top part of the
                        \ main loop

.game2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Platform

 JSR M%                 \ Call M% to iterate through the main flight loop

ENDIF

IF NOT(_NES_VERSION)

 DEC DLY                \ Decrement the delay counter in DLY, so any in-flight
                        \ messages get removed once the counter reaches zero

 BEQ me2                \ If DLY is now 0, jump to me2 to remove any in-flight
                        \ message from the space view, and once done, return to
                        \ me3 below, skipping the following two instructions

 BPL me3                \ If DLY is positive, jump to me3 to skip the next
                        \ instruction

 INC DLY                \ If we get here, DLY is negative, so we have gone too
                        \ and need to increment DLY back to 0

.me3

ENDIF

 DEC MCNT               \ Decrement the main loop counter in MCNT

IF NOT(_ELITE_A_ENCYCLOPEDIA OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 BEQ P%+5               \ If the counter has reached zero, which it will do
                        \ every 256 main loops, skip the next JMP instruction
                        \ (or to put it another way, if the counter hasn't
                        \ reached zero, jump down to MLOOP, skipping all the
                        \ following checks)

.ytq

 JMP MLOOP              \ Jump down to MLOOP to do some end-of-loop tidying and
                        \ restart the main loop

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

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: As the Electron doesn't support witchspace, we always process ship spawning (the other versions skip the ship spawning logic when in witchspace, as the Thargoids are enough trouble without humans joining the fight)

 LDA MJ                 \ If we are in witchspace following a mis-jump, skip the
 BNE ytq                \ following by jumping down to MLOOP (via ytq above)

ELIF _NES_VERSION

 LDA MJ                 \ If we are in witchspace (in which case MJ > 0) or
 ORA demoInProgress     \ demoInProgress > 0 (in which case we are playing the
 BNE ytq                \ demo), jump down to MLOOP (via ytq above)

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 JSR DORND              \ Set A and X to random numbers

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Minor

 CMP #35                \ If A >= 35 (87% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

ELIF _DISC_DOCKED

 CMP #35                \ If A >= 35 (87% chance), jump down to MLOOP to skip
 BCS MLOOP              \ the following

ELIF _ELITE_A_FLIGHT

 CMP #51                \ If A >= 51 (80% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

ELIF _NES_VERSION

 CMP #40                \ If A >= 40 (85% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA MANY+AST           \ If we already have 3 or more asteroids in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

ELIF _DISC_DOCKED

 LDA MANY+AST           \ If we already have 3 or more asteroids in the local
 CMP #3                 \ bubble, jump down to MLOOP to skip the following
 BCS MLOOP

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION

 LDA JUNK               \ If we already have 3 or more bits of junk in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

ENDIF

IF NOT(_ELITE_A_VERSION)

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #38                \ Set z_hi = 38 (far away)
 STA INWK+7

 JSR DORND              \ Set A, X and C flag to random numbers

 STA INWK               \ Set x_lo = random

 STX INWK+3             \ Set y_lo = random
                        \
                        \ Note that because we use the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location. See the deep dive on
                        \ "Fixing ship positions" for details

 AND #%10000000         \ Set x_sign = bit 7 of x_lo
 STA INWK+2

 TXA                    \ Set y_sign = bit 7 of y_lo
 AND #%10000000
 STA INWK+5

 ROL INWK+1             \ Set bit 1 of x_hi to the C flag, which is random, so
 ROL INWK+1             \ this randomly moves us off-centre by 512 (as if x_hi
                        \ is %00000010, then (x_hi x_lo) is 512 + x_lo)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Platform

 JSR DORND              \ Set A, X and V flag to random numbers

 BVS MTT4               \ If V flag is set (50% chance), jump up to MTT4 to
                        \ spawn a trader

ELIF _NES_VERSION

 JSR DORND              \ Set A, X and V flag to random numbers

 AND #%00110000         \ If either of bits 4 and 5 are set (75% chance), skip
 BNE P%+5               \ the following instruction

 JMP MTT4               \ Jump up to MTT4 to spawn a trader (25% chance)

ELIF _ELITE_A_FLIGHT

 JSR rand_posn          \ Call rand_posn to set up the INWK workspace for a ship
                        \ in a random ship position

 BVS MTT4               \ If V flag is set (50% chance), jump up to MTT4 to
                        \ spawn a trader

ENDIF

IF _DISC_FLIGHT \ Other: A bug fix for the first version of disc Elite, in which asteroids never appeared

IF _STH_DISC

 NOP                    \ In the first version of disc Elite, asteroids never
 NOP                    \ appeared. It turned out that the authors had put in a
 NOP                    \ jump to force traders to spawn, so they could test
                        \ that part of the code, but had forgotten to remove it,
                        \ so this was fixed in later versions by replacing the
                        \ JMP instruction with NOPs... and this is where that
                        \ was done

ELIF _IB_DISC

 JMP MTT4               \ In the first version of disc Elite, asteroids never
                        \ appeared. It turned out that the authors had put in a
                        \ jump to force traders to spawn, so they could test
                        \ that part of the code, but had forgotten to remove it,
                        \ so this was fixed in later versions by replacing the
                        \ JMP instruction with NOPs. The version on Ian Bell's
                        \ site still contains the test jump, so asteroids never
                        \ appear in this version

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Platform

 ORA #%01101111         \ Take the random number in A and set bits 0-3 and 5-6,
 STA INWK+29            \ so the result has a 50% chance of being positive or
                        \ negative, and a 50% chance of bits 0-6 being 127.
                        \ Storing this number in the roll counter therefore
                        \ gives our new ship a fast roll speed with a 50%
                        \ chance of having no damping, plus a 50% chance of
                        \ rolling clockwise or anti-clockwise

 LDA SSPR               \ If we are inside the space station safe zone, jump
 BNE MTT1               \ down to MTT1 to skip the following and potentially
                        \ spawn something else

 TXA                    \ Set A to the random X we set above, which we haven't
 BCS MTT2               \ used yet, and if the C flag is set (50% chance) jump
                        \ down to MTT2 to skip the following

 AND #31                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

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

ELIF _NES_VERSION

 ORA #%01101111         \ Take the random number in A and set bits 0-3 and 5-6,
 STA INWK+29            \ so the result has a 50% chance of being positive or
                        \ negative, and a 50% chance of bits 0-6 being 127.
                        \ Storing this number in the roll counter therefore
                        \ gives our new ship a fast roll speed with a 50%
                        \ chance of having no damping, plus a 50% chance of
                        \ rolling clockwise or anti-clockwise

 LDA SSPR               \ If we are inside the space station safe zone, jump
 BNE MLOOPS             \ down to MLOOPS to stop spawning

 TXA                    \ Set A to the random X we set above, which we haven't
 BCS MTT2               \ used yet, and if the C flag is set (50% chance) jump
                        \ down to MTT2 to skip the following

 AND #31                \ Set the ship speed to our random number, reduced to
 ORA #16                \ the range 16 to 31
 STA INWK+27

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

ELIF _ELITE_A_FLIGHT

 ORA #%01101111         \ Take the random number in A and set bits 0-3 and 5-6,
 STA INWK+29            \ so the result has a 50% chance of being positive or
                        \ negative, and a 50% chance of bits 0-6 being 127.
                        \ Storing this number in the roll counter therefore
                        \ gives our new ship a fast roll speed with a 50%
                        \ chance of having no damping, plus a 50% chance of
                        \ rolling clockwise or anti-clockwise

 LDA SSPR               \ If we are inside the space station safe zone, jump
 BNE MLOOPS             \ down to MLOOPS to stop spawning

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

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Advanced: In the advanced versions, 1.2% of asteroids spawned are rock hermits

 CMP #252               \ If random A < 252 (98.8% of the time), jump to thongs
 BCC thongs             \ to skip the following

 LDA #HER               \ Set A to #HER so we spawn a rock hermit 1.2% of the
                        \ time

 STA INWK+32            \ Set byte #32 to %00001111 to give the rock hermit an
                        \ E.C.M.

 BNE whips              \ Jump to whips (this BNE is effectively a JMP as A will
                        \ never be zero)

.thongs

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette version, 1.5% of asteroids are actually spawned as cargo canisters, while in the enhanced versions 4% of asteroids are spawned as either cargo canisters or alloy plates, with an even chance of each

 CMP #5                 \ Set A to the ship number of an asteroid, and keep
 LDA #AST               \ this value for 98.5% of the time (i.e. if random
 BCS P%+4               \ A >= 5 then skip the following instruction)

 LDA #OIL               \ Set A to the ship number of a cargo canister

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION

 CMP #10                \ If random A >= 10 (96% of the time), set the C flag

 AND #1                 \ Reduce A to a random number that's 0 or 1

 ADC #OIL               \ Set A = #OIL + A + C, so there's a tiny chance of us
                        \ spawning a cargo canister (#OIL) and an even chance of
                        \ us spawning either a boulder (#OIL + 1) or an asteroid
                        \ (#OIL + 2)

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Label

.whips

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Platform

 JSR NWSHP              \ Add our new asteroid or canister to the universe

ELIF _ELITE_A_FLIGHT

 BNE horde_plain        \ Jump to horde_plain to spawn a whole pack of cargo
                        \ canisters, boulders or asteroids, according to the
                        \ value of A (the BNE is effectively a JMP, as A will
                        \ never be zero)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

                        \ Fall through into part 5 (parts 3 and 4 are not
                        \ required when we are docked)

ENDIF

