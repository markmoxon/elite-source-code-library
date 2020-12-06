\ ******************************************************************************
\
\       Name: EXNO2
\       Type: Subroutine
\   Category: Sound
\    Summary: Process us making a kill
\
\ ------------------------------------------------------------------------------
\
\ We have killed a ship, so increase the kill tally, displaying an iconic
\ message of encouragement if the kill total is a multiple of 256, and then
\ make a nearby explosion sound.
\
\ Other entry points:
\
\   EXNO-2              Set X = 7 and fall through into EXNO to make the sound
\                       of a ship exploding
\
\ ******************************************************************************

.EXNO2

 INC TALLY              \ Increment the low byte of the kill count in TALLY

 BNE EXNO-2             \ If there is no carry, jump to the LDX #7 below (at
                        \ EXNO-2)

 INC TALLY+1            \ Increment the high byte of the kill count in TALLY

 LDA #101               \ The kill total is a multiple of 256, so it's time
 JSR MESS               \ for a pat on the back, so print recursive token 101
                        \ ("RIGHT ON COMMANDER!") as an in-flight message

 LDX #7                 \ Set X = 7 and fall through into EXNO to make the
                        \ sound of a ship exploding

