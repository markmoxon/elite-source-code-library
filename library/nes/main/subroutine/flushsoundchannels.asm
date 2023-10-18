\ ******************************************************************************
\
\       Name: FlushSoundChannels
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush the SQ1, SQ2 and NOISE sound channels
\
\ ******************************************************************************

.FlushSoundChannels

 LDX #0                 \ Flush the SQ1 sound channel
 JSR FlushSoundChannel

                        \ Fall through into FlushSQ2AndNOISE to flush the SQ2
                        \ and NOISE channels

