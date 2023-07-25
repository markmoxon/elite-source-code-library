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

 LDA INWK+7             \ ???
 LDX #0
 CMP #&10
 BCS CBEA5
 INX
 CMP #8
 BCS CBEA5
 INX
 CMP #6
 BCS CBEA5
 INX
 CMP #3
 BCS CBEA5
 INX

.CBEA5

 LDY LBEAB,X
 JMP NOISE

ENDIF

