\ ******************************************************************************
\
\       Name: BDRO9
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#9> to restart the current tune
\
\ ******************************************************************************

.BDRO9

 LDA #0                 \ Clear the current music data byte, which discards the
 STA BDBUFF             \ next nibble if there is one (so this flushes any data
                        \ from the current pipeline)

 LDA BDdataptr3         \ Set BDdataptr1(1 0) = BDdataptr3(1 0)
 STA BDdataptr1         \
 LDA BDdataptr4         \ So this sets the data pointer in BDdataptr1(1 0) back
 STA BDdataptr2         \ to the original value that we gave it at the start of
                        \ the BDENTRY routine when we started playing this tune,
                        \ which we stored in BDdataptr3(1 0)
                        \
                        \ In other words, this restarts the current tune

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

