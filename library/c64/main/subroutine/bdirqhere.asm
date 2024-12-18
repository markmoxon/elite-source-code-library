\ ******************************************************************************
\
\       Name: BDirqhere
\       Type: Subroutine
\   Category: Sound
\    Summary: The interrupt routine for playing background music
\  Deep dive: Music in Commodore 64 Elite
\
\ ------------------------------------------------------------------------------
\
\ The label "BD" is used as a prefix throughout the music routines. This is a
\ reference to the Blue Danube, which is the only bit of music that was included
\ in the first release of Commodore 64 Elite (where it was used for the docking
\ computer). The Elite Theme that plays on the title screen was added in a later
\ release.
\
\ The following comments appear in the original source:
\
\ Music driver by Dave Dunn.
\
\ BBC source code converted from Commodore disassembly extremely badly
\ Jez. 13/4/85.
\
\ Music system (c)1985 D.Dunn.
\ Modified by IB,DB
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BDskip1             Process the next nibble of music data in BDBUFF
\
\ ******************************************************************************

.BDirqhere

 LDY #0                 \ If the music counter is zero then we are not currently
 CPY counter            \ processing a wait command, so jump to BDskip1 to
 BEQ BDskip1            \ process the current byte of music data in BDBUFF

 DEC counter            \ Otherwise we are processing a rest command, so
                        \ decrement the music counter while we continue to pause
                        \ the music

 JMP BDlab1             \ And jump to BDlab1 to update the vibrato and control
                        \ registers before returning from the subroutine

.BDskip1

                        \ When we get here, Y is set to 0
                        \
                        \ This value is retained throughout the entire music
                        \ interrupt routine, so whenever you see Y in these
                        \ routines, it has a value of 0

 LDA BDBUFF             \ Set A to the current byte of music data in BDBUFF

 CMP #&10               \ If A >= &10 then the high nibble of A is non-zero, so
 BCS BDLABEL2           \ jump to BDLABEL2 to extract and process the command in
                        \ the low nibble first (the command in the high nibble
                        \ then gets moved into the low nibble to be processed
                        \ next)

 TAX                    \ Set X to the low nibble of music data in A, so X is
                        \ in the range 1 to 15 and contains the number of the
                        \ music command we now need to process

 BNE BDLABEL            \ If A > 0 then this is a valid command number in the
                        \ range 1 to 15, so jump to BDLABEL to process the
                        \ command

                        \ If we get here then the nibble of music data in A is
                        \ zero, which means "do nothing", so we just move on to
                        \ the next data byte

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA BDBUFF             \ Store the next music data byte in BDBUFF

.BDLABEL2

 AND #&0F               \ Extract the low nibble of the music data into A

 TAX                    \ Set X to the low nibble of music data in A, so X is
                        \ in the range 1 to 15 and contains the number of the
                        \ music command we now need to process

.BDLABEL

 LDA BDBUFF             \ Shift the high nibble of BDBUFF into the low nibble,
 LSR A                  \ so it is available as the next nibble of music data
 LSR A                  \ to be processed, once we have finished processing the
 LSR A                  \ command in X
 LSR A
 STA BDBUFF

                        \ We now process the current music command, which is in
                        \ the low nibble of X, and in the range 1 to 15

 LDA BDJMPTBL-1,X       \ Modify the JMP command at BDJMP to jump to the X-th
 STA BDJMP+1            \ address in the BDJMPTBL table, to process the music
 LDA BDJMPTBH-1,X       \ command in X
 STA BDJMP+2            \
                        \ This means that command <#1> jumps to BDRO1, command
                        \ <#2> jumps to BDRO2, and so on up to command <#15>,
                        \ which jumps to BDR15

.BDJMP

 JMP BDskip1            \ Jump to the correct routine for processing the music
                        \ command in X (as this instruction gets modified)

