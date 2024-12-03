\ ******************************************************************************
\
\       Name: BDlab3
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 1 (high byte then low byte)
\
\ ******************************************************************************

.BDlab3

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&1             \ Set SID register &1 to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&0             \ Set SID register &0 to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 1

 RTS                    \ Return from the subroutine

