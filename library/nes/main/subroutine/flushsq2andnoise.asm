\ ******************************************************************************
\
\       Name: FlushSQ2AndNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush the SQ2 and NOISE sound channels
\
\ ******************************************************************************

.FlushSQ2AndNOISE

 LDX #1                 \ Flush the SQ2 sound channel
 JSR FlushSoundChannel

 LDX #2                 \ Flush the NOISE sound channel, returning from the
 BNE FlushSoundChannel  \ subroutine using a tail call

