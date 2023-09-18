\ ******************************************************************************
\
\       Name: EXNO2
\       Type: Subroutine
\   Category: Status
\    Summary: Process us making a kill
\  Deep dive: Combat rank
\
\ ------------------------------------------------------------------------------
\
\ We have killed a ship, so increase the kill tally, displaying an iconic
\ message of encouragement if the kill total is a multiple of 256, and then
\ make a nearby explosion sound.
\
IF _MASTER_VERSION \ Comment
\ Arguments:
\
\   X                   The type of the ship that was killed
ENDIF
\
\ ******************************************************************************

.EXNO2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master version incorporates a fractional kill tally when calculating the combat rank, so each ship type has a different number of kill points, while all the other versions count one point for each kill

 INC TALLY              \ Increment the low byte of the kill count in TALLY

 BNE EXNO-2             \ If there is no carry, jump to the LDX #7 below (at
                        \ EXNO-2)

ELIF _MASTER_VERSION

 LDA TALLYL             \ We now add the fractional kill count to our tally,
 CLC                    \ starting with the fractional bytes:
 ADC KWL%-1,X           \
 STA TALLYL             \   TALLYL = TALLYL + fractional kill count
                        \
                        \ where the fractional kill count is taken from the
                        \ KWL% table, according to the ship's type (we look up
                        \ the X-1-th value from KWL% because ship types start
                        \ at 1 rather than 0)

 LDA TALLY              \ And then we add the low byte of TALLY(1 0):
 ADC KWH%-1,X           \
 STA TALLY              \   TALLY = TALLY + carry + integer kill count
                        \
                        \ where the integer kill count is taken from the KWH%
                        \ table in the same way

 BCC davidscockup       \ If there is no carry, jump straight to EXNO3 to skip
                        \ the following three instructions

ELIF _NES_VERSION

 JSR IncreaseTally      \ Add double the fractional kill count to the fractional
                        \ and low bytes of our tally, setting the C flag if the
                        \ addition overflowed

 BCC davidscockup       \ If there is no carry, jump straight to EXNO3 to skip
                        \ the following three instructions

ENDIF

 INC TALLY+1            \ Increment the high byte of the kill count in TALLY

 LDA #101               \ The kill total is a multiple of 256, so it's time
 JSR MESS               \ for a pat on the back, so print recursive token 101
                        \ ("RIGHT ON COMMANDER!") as an in-flight message

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDX #7                 \ Set X = 7 and fall through into EXNO to make the
                        \ sound of a ship exploding

ELIF _MASTER_VERSION

.davidscockup

                        \ Fall through into EXNO3 to make the sound of a
                        \ ship exploding

ELIF _NES_VERSION

.davidscockup

 LDA INWK+7             \ Fetch z_hi, the distance of the ship being hit in
                        \ terms of the z-axis (in and out of the screen)

 LDX #0                 \ We now set X to a number between 0 and 4 depending on
                        \ the z-axis distance to the exploding ship, with 0
                        \ for distant ships and 4 for close ships

 CMP #16                \ If z_hi >= 16, jump to exno1 with X = 0
 BCS exno1

 INX                    \ Increment X to 1

 CMP #8                 \ If z_hi >= 8, jump to exno1 with X = 1
 BCS exno1

 INX                    \ Increment X to 2

 CMP #6                 \ If z_hi >= 6, jump to exno1 with X = 2
 BCS exno1

 INX                    \ Increment X to 3

 CMP #3                 \ If z_hi >= 3, jump to exno1 with X = 3
 BCS exno1

 INX                    \ Increment X to 4

.exno1

 LDY explosionNoises,X  \ Set Y to the X-th noise number from the table of
                        \ explosion noise numbers

 JMP NOISE              \ Call the NOISE routine to make the sound in Y, which
                        \ will be the sound of a ship exploding at the specified
                        \ distance, returning from the subroutine using a tail
                        \ call

ENDIF

