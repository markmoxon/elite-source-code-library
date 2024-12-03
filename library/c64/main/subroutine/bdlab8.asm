\ ******************************************************************************
\
\       Name: BDlab8
\       Type: Subroutine
\   Category: Sound
\    Summary: Set the voice control register for voice 3 to value3
\
\ ******************************************************************************

.BDlab8

 LDA value3             \ Set A to value3, to use as the new value of the voice
                        \ control register for voice 3

 STY SID+&12            \ Zero SID register &12 (the voice control register for
                        \ voice 3), to reset the voice control

 STA SID+&12            \ Set SID register &12 (the voice control register for
                        \ voice 3) to the music data byte that we just fetched
                        \ in A, so control the voice as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \   * Bit 1 set = synchronization enabled
                        \
                        \   * Bit 2 set = ring modulation enabled
                        \
                        \   * Bit 3 set = disable voice, reset noise generator
                        \
                        \   * Bit 4 set = triangle waveform enabled
                        \
                        \   * Bit 5 set = saw waveform enabled
                        \
                        \   * Bit 6 set = square waveform enabled
                        \
                        \   * Bit 7 set = noise waveform enabled

 RTS                    \ Return from the subroutine

