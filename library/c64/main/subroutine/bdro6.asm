\ ******************************************************************************
\
\       Name: BDRO6
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#6> to increment value0 and move on to the
\             next nibble of music data
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO6

 INC value0             \ Increment the counter in value0
                        \
                        \ This value is never read, so it could be a debugging
                        \ command of some kind, or a counter that is not used
                        \ by the music in Elite

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

