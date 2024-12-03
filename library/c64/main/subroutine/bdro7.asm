\ ******************************************************************************
\
\       Name: BDRO7
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#7 ad1 ad2 ad3 sr1 sr2 sr3> to set three
\             voices' attack and decay length, sustain volume and release length
\
\ ******************************************************************************

.BDRO7

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&5             \ Set SID register &5 to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 1 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&C             \ Set SID register &C to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 2 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&13            \ Set SID register &12 to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 3 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&6             \ Set SID register &6 to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 1 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&D             \ Set SID register &D to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 2 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&14            \ Set SID register &14 to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 4 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

