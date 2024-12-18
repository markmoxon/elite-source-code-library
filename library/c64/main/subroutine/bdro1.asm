\ ******************************************************************************
\
\       Name: BDRO1
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#1 fh1 fl1> to set the frequency for voice
\             1 to (fh1 fl1) and the control register for voice 1 to value1
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO1

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

