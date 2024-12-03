\ ******************************************************************************
\
\       Name: BDRO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#3 fh1 fl1> to set the frequency for voice
\             3 to (fh3 fl3) and the control register for voice 3 to value3
\
\ ******************************************************************************

.BDRO3

 JSR BDlab7             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 3 (high byte then low byte) and the
                        \ vibrato variables for voice 3

 JSR BDlab8             \ Set the voice control register for voice 3 to value3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

