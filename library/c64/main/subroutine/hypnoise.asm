\ ******************************************************************************
\
\       Name: HYPNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of the hyperspace drive being engaged
\
\ ******************************************************************************

.HYPNOISE

 LDY #sfxhyp1           \ Call the NOISE2 routine with Y = sfxhyp1, a frequency
 LDA #&F5               \ of 240 in X, and A set as follows:
 LDX #240               \
 JSR NOISE2             \   * Low nibble of A = release length of 5
                        \
                        \   * High nibble of A = sustain volume of 15

 LDY #sfxwhosh          \ Call the NOISE routine with Y = sfxwhosh to make the
 JSR NOISE              \ sound of the ship launching

 LDY #1                 \ Wait for 1 vertical sync (1/50 = 0.02 seconds)
 JSR DELAY

 LDY #(sfxhyp1+128)     \ Call the NOISE routine with Y = sfxhyp1 + 128, which
 BNE NOISE              \ makes the sfxhyp1 hyperspace effect, but without first
                        \ checking to see if it is already playing (so the
                        \ effect can layer on top of the first sound effect we
                        \ made above)
                        \
                        \ The call to NOISE returns from the subroutine using a
                        \ tail call (this BNE is effectively a JMP as Y is never
                        \ zero)

