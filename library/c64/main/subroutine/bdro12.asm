\ ******************************************************************************
\
\       Name: BDRO12
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#12 n> to set value4 = n, which sets the
\             rest length for commands #8 and #15
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO12

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value4             \ Set value4 to the value of the byte we just fetched,
                        \ which sets the rest length used in commands #8 and #15

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

