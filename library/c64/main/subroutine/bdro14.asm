\ ******************************************************************************
\
\       Name: BDRO14
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#14 vf fc cf> to set the volume and filter
\             modes, filter control and filter cut-off frequency
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO14

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&18            \ Set SID register &18 to the music data byte we just
                        \ fetched, which sets the volume and filter modes as
                        \ follows:
                        \
                        \   * Bits 0-3: volume (0 to 15)
                        \
                        \   * Bit 4 set: enable the low-pass filter
                        \
                        \   * Bit 5 set: enable the bandpass filter
                        \
                        \   * Bit 6 set: enable the high-pass filter
                        \
                        \   * Bit 7 set: disable voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&17            \ Set SID register &17 to the music data byte we just
                        \ fetched, which sets the filter control as follows:
                        \
                        \   * Bit 0 set: voice 1 filtered
                        \
                        \   * Bit 1 set: voice 2 filtered
                        \
                        \   * Bit 2 set: voice 3 filtered
                        \
                        \   * Bit 3 set: external voice filtered
                        \
                        \   * Bits 4-7: filter resonance

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&16            \ Set SID register &16 to the music data byte we just
                        \ fetched, which sets bits 3 to 10 of the filter cut-off
                        \ frequency

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

