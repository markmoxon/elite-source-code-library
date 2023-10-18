\ ******************************************************************************
\
\       Name: MakeHyperSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the hyperspace sound
\
\ ******************************************************************************

.MakeHyperSound

 JSR FlushSoundChannels \ Flush the SQ1, SQ2 and NOISE sound channels

 LDY #21                \ Set Y = 21 and fall through into the NOISE routine to
                        \ make the hyperspace sound

