\ ******************************************************************************
\
\       Name: ResetMusic
\       Type: Subroutine
\   Category: Sound
\    Summary: Reset the current tune to the default and stop all sounds (music
\             and sound effects)
\
\ ******************************************************************************

.ResetMusic

 LDA #0                 \ Set newTune to select the default tune (tune 0, the
 STA newTune            \ "Elite Theme") and clear bit 7 to indicate we are not
                        \ in the process of changing tunes

                        \ Fall through into StopSounds_b6 to stop all sounds
                        \ (music and sound effects)

