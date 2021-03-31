\ ******************************************************************************
\
\       Name: EXNO2
\       Type: Subroutine
\   Category: Sound
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
\ Other entry points:
\
\   EXNO-2              Set X = 7 and fall through into EXNO to make the sound
\                       of a ship exploding
\
\ ******************************************************************************

.EXNO2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 INC TALLY              \ Increment the low byte of the kill count in TALLY

 BNE EXNO-2             \ If there is no carry, jump to the LDX #7 below (at
                        \ EXNO-2)

ELIF _MASTER_VERSION

 LDA TALLYF             \ We now add the fractional kill count to our tally,
 CLC                    \ starting by with the fractional bytes:
 ADC TALLYFRAC-1,X      \
 STA TALLYF             \   TALLYF = TALLYF + fractional kill count
                        \
                        \ where the fractional kill count is taken from the
                        \ TALLYFRAC table, according to the ship's type (we
                        \ look up the X-1-th value from TALLYFRAC because ship
                        \ types start at 1 rather than 0)

 LDA TALLY              \ And then we add the low byte of TALLY(1 0):
 ADC TALLYINT-1,X       \
 STA TALLY              \   TALLY = TALLY + carry + integer kill count
                        \
                        \ where the integer kill count is taken from the
                        \ TALLYINT table in the same way

 BCC EXNO3              \ If there is no carry, jump straight to EXNO3 to skip
                        \ the following three instructions

ENDIF

 INC TALLY+1            \ Increment the high byte of the kill count in TALLY

 LDA #101               \ The kill total is a multiple of 256, so it's time
 JSR MESS               \ for a pat on the back, so print recursive token 101
                        \ ("RIGHT ON COMMANDER!") as an in-flight message

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDX #7                 \ Set X = 7 and fall through into EXNO to make the
                        \ sound of a ship exploding

ELIF _MASTER_VERSION

                        \ Fall through into EXNO3 to make the sound of a
                        \ ship exploding

ENDIF

