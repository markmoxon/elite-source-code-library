\ ******************************************************************************
\
\       Name: MakeMusic
\       Type: Subroutine
\   Category: Sound
\    Summary: Play the current music on the SQ1, SQ2, TRI and NOISE channels
\
\ ******************************************************************************

.MakeMusic

 LDA enableSound        \ If enableSound is non-zero then sound is enabled, so
 BNE makm1              \ jump to makm1 to play the current music

 RTS                    \ Otherwise sound is disabled, so return from the
                        \ subroutine

.makm1

 LDA tuneSpeed          \ Set tuneProgress = tuneProgress + tuneSpeed
 CLC                    \
 ADC tuneProgress       \ This moves the tune along by the current speed,
 STA tuneProgress       \ setting the C flag only when the addition of this
                        \ iteration's speed overflows the addition
                        \
                        \ This ensures that we only send music to the APU once
                        \ every 256 / tuneSpeed iterations, which keeps the
                        \ music in sync and sends the music more regularly with
                        \ higher values of tuneSpeed

 BCC makm2              \ If the addition didn't overflow, jump to makm2 to skip
                        \ playing music in this VBlank

 JSR MakeMusicOnSQ1     \ Play the current music on the SQ1 channel

 JSR MakeMusicOnSQ2     \ Play the current music on the SQ2 channel

 JSR MakeMusicOnTRI     \ Play the current music on the TRI channel

 JSR MakeMusicOnNOISE   \ Play the current music on the NOISE channel

.makm2

 JSR ApplyEnvelopeSQ1   \ Apply volume and pitch changes to the SQ1 channel

 JSR ApplyEnvelopeSQ2   \ Apply volume and pitch changes to the SQ2 channel

 JSR ApplyEnvelopeTRI   \ Apply volume and pitch changes to the TRI channel

 JMP ApplyEnvelopeNOISE \ Apply volume and pitch changes to the NOISE channel,
                        \ returning from the subroutine using a tail call

