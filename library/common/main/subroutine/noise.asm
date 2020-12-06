\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound whose number is in A
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound to be made. See the
\                       documentation for variable SFX for a list of sound
\                       numbers
\
\ ******************************************************************************

.NOISE

 JSR NOS1               \ Set up the sound block in XX16 for the sound in A and
                        \ fall through into NO3 to make the sound

