\ ******************************************************************************
\
\       Name: BDRO5
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#5 fh1 fl1 fh2 fl2 fh3 fl3> to set the
\             frequencies and voice control registers for voices 1, 2 and 3
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO5

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab7             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 3 (high byte then low byte) and the
                        \ vibrato variables for voice 3

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JSR BDlab8             \ Set the voice control register for voice 3 to value3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

