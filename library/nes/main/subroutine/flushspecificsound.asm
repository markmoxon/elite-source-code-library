\ ******************************************************************************
\
\       Name: FlushSpecificSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush the channels used by a specific sound
\
\ ------------------------------------------------------------------------------
\
\ The sound channels are flushed according to the specific sound's value in the
\ soundChannel table:
\
\   * If soundChannel = 0, flush the SQ1 sound channel
\
\   * If soundChannel = 1, flush the SQ2 sound channel
\
\   * If soundChannel = 2, flush the NOISE sound channel
\
\   * If soundChannel = 3, flush the SQ1 and NOISE sound channels
\
\   * If soundChannel = 4, flush the SQ2 and NOISE sound channels
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the sound to flush
\
\ ******************************************************************************

.FlushSpecificSound

 LDX soundChannel,Y     \ Set X to the sound channel for sound Y

 CPX #3                 \ If X < 3 then jump to FlushSoundChannel to flush the
 BCC FlushSoundChannel  \ SQ1, SQ2 or NOISE sound channel, as specified in X,
                        \ returning from the subroutine using a tail call

 BNE FlushSQ2AndNOISE   \ If X <> 3, i.e. X = 4, then jump to FlushSQ2AndNOISE
                        \ to flush sound channels 1 and 2, returning from the
                        \ subroutine using a tail call

                        \ If we get here then we know X = 3, so now we flush the
                        \ SQ1 and NOISE sound channels

 LDX #0                 \ Flush the SQ1 sound channel
 JSR FlushSoundChannel

 LDX #2                 \ Set X = 2 and fall through into FlushSoundChannel to
                        \ flush the NOISE sound channel

