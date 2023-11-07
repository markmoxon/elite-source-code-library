\ ******************************************************************************
\
\       Name: StartEffect
\       Type: Subroutine
\   Category: Sound
\    Summary: Start making a sound effect on the specified channel
\  Deep dive: Sound effects in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound effect to make
\
\   X                   The sound channel on which to make the sound effect:
\
\                         * 0 = SQ1
\
\                         * 1 = SQ2
\
\                         * 2 = NOISE
\
\ ******************************************************************************

.StartEffect

 DEX                    \ Decrement the channel number in X, so we can check the
                        \ value in the following tests

 BMI msef1              \ If X is now negative then the channel number must be
                        \ 0, so jump to msef1 to make the sound effect on the
                        \ SQ1 channel

 BEQ StartEffectOnSQ2   \ If X is now zero then the channel number must be 1, so
                        \ jump to StartEffectOnSQ2 to start making the sound
                        \ effect on the SQ2 channel, returning from the
                        \ subroutine using a tail call

 JMP StartEffectOnNOISE \ Otherwise the channel number must be 2, so jump to
                        \ StartEffectOnNOISE to make the sound effect on the
                        \ NOISE channel, returning from the subroutine using a
                        \ tail call

.msef1

 JMP StartEffectOnSQ1   \ Jump to StartEffectOnSQ1 to start making the sound
                        \ effect on the SQ1 channel, returning from the
                        \ subroutine using a tail call

