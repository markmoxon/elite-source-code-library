\ ******************************************************************************
\
\       Name: MakeSounds
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the current sounds (music and sound effects)
\  Deep dive: Sound effects in NES Elite
\             Music in NES Elite
\
\ ******************************************************************************

.MakeSounds

 JSR MakeMusic          \ Calculate the current music on the SQ1, SQ2, TRI and
                        \ NOISE channels

 JSR MakeSound          \ Calculate the current sound effects on the SQ1, SQ2
                        \ and NOISE channels

 LDA enableSound        \ If enableSound = 0 then sound is disabled, so jump to
 BEQ maks3              \ maks3 to return from the subroutine

 LDA effectOnSQ1        \ If effectOnSQ1 is non-zero then a sound effect is
 BNE maks1              \ being made on channel SQ1, so jump to maks1 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 LDA sq1Volume          \ Send sq1Volume to the APU via SQ1_VOL
 STA SQ1_VOL

 LDA sq1Sweep           \ If sq1Sweep is non-zero then there is a sweep unit in
 BNE maks1              \ play on channel SQ1, so jump to maks1 to skip the
                        \ following as the sweep will take care of the pitch

 LDA sq1Lo              \ Otherwise send sq1Lo to the APU via SQ1_LO to set the
 STA SQ1_LO             \ pitch on channel SQ1

.maks1

 LDA effectOnSQ2        \ If effectOnSQ2 is non-zero then a sound effect is
 BNE maks2              \ being made on channel SQ2, so jump to maks2 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 LDA sq2Volume          \ Send sq2Volume to the APU via SQ2_VOL
 STA SQ2_VOL

 LDA sq2Sweep           \ If sq2Sweep is non-zero then there is a sweep unit in
 BNE maks2              \ play on channel SQ2, so jump to maks2 to skip the
                        \ following as the sweep will take care of the pitch

 LDA sq2Lo              \ Otherwise send sq2Lo to the APU via SQ2_LO to set the
 STA SQ2_LO             \ pitch on channel SQ2

.maks2

 LDA triLo              \ Send triLo to the APU via TRI_LO
 STA TRI_LO

 LDA effectOnNOISE      \ If effectOnNOISE is non-zero then a sound effect is
 BNE maks3              \ being made on channel NOISE, so jump to maks3 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 LDA noiseVolume        \ Send noiseVolume to the APU via NOISE_VOL
 STA NOISE_VOL

 LDA noiseLo            \ Send noiseLo to the APU via NOISE_LO
 STA NOISE_LO

.maks3

 RTS                    \ Return from the subroutine

