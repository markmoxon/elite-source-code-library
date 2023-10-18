\ ******************************************************************************
\
\       Name: MakeSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the current sound effects on the SQ1, SQ2 and NOISE channels
\
\ ******************************************************************************

.MakeSound

 JSR UpdateVibratoSeeds \ Update the sound seeds that are used to randomise the
                        \ vibrato effect

 JSR MakeSoundOnSQ1     \ Make the current sound effect on the SQ1 channel

 JSR MakeSoundOnSQ2     \ Make the current sound effect on the SQ2 channel

 JMP MakeSoundOnNOISE   \ Make the current sound effect on the NOISE channel,
                        \ returning from the subroutine using a tail call

