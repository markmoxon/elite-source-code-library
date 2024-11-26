\ ******************************************************************************
\
\       Name: NOISEOFF
\       Type: Subroutine
\   Category: Sound
\    Summary: Turn off a specific sound effect in whichever voice it is
\             currently playing in
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the sound effect to turn off
\
\ ******************************************************************************

.NOISEOFF

 LDX #3                 \ Set X = 3 to use as a counter to work through the
                        \ three voices, so we can match the voice that is
                        \ currently playing the sound effect in Y

 INY                    \ Set XX15+2 to the number of the sound effect we want
 STY XX15+2             \ to turn off, plus 1

.SOUL1

 DEX                    \ Decrement X to work through the voices, so we start
                        \ from 2 and go down to 0

 BMI SOUR1              \ If X is negative then we have checked all three
                        \ voices, jump to SOUR1 to return from the subroutine
                        \ (as SOUR1 contains an RTS)

 LDA SOFLG,X            \ Set A to bits 0-5 of SOFLG for voice X
 AND #%00111111

 CMP XX15+2             \ If this doesn't match the incremented sound effect
 BNE SOUL1              \ number in XX15+2, loop back to check the next voice

 LDA #1                 \ If we get here then voice X is playing the sound
 STA SOCNT,X            \ effect we want to stop, so set the SOCNT entry for
                        \ this voice to 1, to run down the sound's counter and
                        \ stop the sound

 RTS                    \ Return from the subroutine

