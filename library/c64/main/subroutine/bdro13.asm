\ ******************************************************************************
\
\       Name: BDRO13
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#13 v1 v2 v3> to set value1, value2, value3
\             to the voice control register valuesm for commands <#1> to <#3>
\
\ ******************************************************************************

.BDRO13

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value1             \ Set value1 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 1 in command <#1>

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value2             \ Set value2 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 2 in command <#2>

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value3             \ Set value3 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 3 in command <#3>

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

