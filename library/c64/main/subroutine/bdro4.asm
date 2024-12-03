\ ******************************************************************************
\
\       Name: BDRO4
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#4 fh1 fl1 fh2 fl2> to set the frequencies
\             and voice control registers for voices 1 and 2
\
\ ******************************************************************************

.BDRO4

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

