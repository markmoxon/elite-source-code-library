\ ******************************************************************************
\
\       Name: BDRO2
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#2 fh1 fl1> to set the frequency for voice
\             2 to (fh2 fl2) and the control register for voice 2 to value2
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO2

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

