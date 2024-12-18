\ ******************************************************************************
\
\       Name: BDRO10
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#10 h1 l1 h2 l2 h3 l3> to set the pulse
\             width to all three voices
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO10

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&2             \ Set SID register &2 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&3             \ Set SID register &3 to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&9             \ Set SID register &9 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&A             \ Set SID register &A to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&10            \ Set SID register &10 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 3

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&11            \ Set SID register &11 to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

