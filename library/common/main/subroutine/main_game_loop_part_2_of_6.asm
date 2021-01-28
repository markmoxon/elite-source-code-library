\ ******************************************************************************
\
\       Name: Main game loop (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Call main flight loop, potentially spawn trader, asteroid, cargo
\
\ ------------------------------------------------------------------------------
\
IF _DISC_DOCKED
\ In the docked code, we start the main game loop at part 2 and then jump
\ straight to part 5, as parts 1, 3 and 4 are not required when we are docked.
\
ENDIF
\ This section covers the following:
\
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT
\   * Call M% to do the main flight loop
\
ENDIF
\   * Potentially spawn a trader (Cobra Mk III), asteroid or cargo canister
\
\ Other entry points:
\
\   TT100               The entry point for the start of the main game loop,
\                       which calls the main flight loop and the moves into the
\                       spawning routine
\
\   me3                 Used by me2 to jump back into the main game loop after
\                       printing an in-flight message
\
\ ******************************************************************************

.TT100

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 JSR M%                 \ Call M% to iterate through the main flight loop

ENDIF

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

 DEC MCNT               \ Decrement the main loop counter in MCNT

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

 LDA MJ                 \ If we are in witchspace following a mis-jump, skip the
 BNE ytq                \ following by jumping down to MLOOP (via ytq above)

 JSR DORND              \ Set A and X to random numbers

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 CMP #35                \ If A >= 35 (87% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

ELIF _DISC_DOCKED

 CMP #35                \ If A >= 35 (87% chance), jump down to MLOOP to skip
 BCS MLOOP              \ the following

ENDIF

IF _CASSETTE_VERSION

 LDA MANY+AST           \ If we already have 3 or more asteroids in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

ELIF _DISC_DOCKED

 LDA MANY+AST           \ If we already have 3 or more asteroids in the local
 CMP #3                 \ bubble, jump down to MLOOP to skip the following
 BCS MLOOP

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 LDA JUNK               \ If we already have 3 or more bits of junk in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

ENDIF

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #38                \ Set z_hi = 38 (far away)
 STA INWK+7

 JSR DORND              \ Set A, X and C flag to random numbers

 STA INWK               \ Set x_lo = random

 STX INWK+3             \ Set y_lo = random

 AND #%10000000         \ Set x_sign = bit 7 of x_lo
 STA INWK+2

 TXA                    \ Set y_sign = bit 7 of y_lo
 AND #%10000000
 STA INWK+5

 ROL INWK+1             \ Set bit 2 of x_hi to the C flag, which is random, so
 ROL INWK+1             \ this randomly moves us slightly off-centre

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 JSR DORND              \ Set A, X and V flag to random numbers

 BVS MTT4               \ If V flag is set (50% chance), jump up to MTT4 to
                        \ spawn a trader

ENDIF

IF _DISC_FLIGHT

 NOP                    \ ????
 NOP
 NOP

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

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

ENDIF

IF _CASSETTE_VERSION

 CMP #5                 \ Set A to the ship number of an asteroid, and keep
 LDA #AST               \ this value for 98.5% of the time (i.e. if random
 BCS P%+4               \ A >= 5 then skip the following instruction)

 LDA #OIL               \ Set A to the ship number of a cargo canister

ELIF _6502SP_VERSION

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

IF _6502SP_VERSION OR _DISC_FLIGHT

 CMP #10                \ If random A >= 10 (96% of the time), set the C flag

 AND #1                 \ Reduce A to a random number that's 0 or 1

 ADC #OIL               \ Set A = #OIL + A + C, so there's a tiny chance of us
                        \ spawning a cargo canister (#OIL) and an even chance of
                        \ us spawning either a boulder (#OIL + 1) or an asteroid
                        \ (#OIL + 2)

ENDIF

IF _6502SP_VERSION

.whips

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 JSR NWSHP              \ Add our new asteroid or canister to the universe

ENDIF

IF _DISC_DOCKED

                        \ Fall through into part 5 (parts 3 and 4 are not
                        \ required when we are docked)

ENDIF

