\ ******************************************************************************
\
\       Name: CopyCode2
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy CODE2 from &4000-&6FFF to &9000-&BFFF
\
\ ******************************************************************************

.CopyCode2

 LDA #&00               \ Set fromAddr(1 0) = &4000
 STA fromAddr
 LDA #&40
 STA fromAddr+1

 LDA #&00               \ Set toAddr(1 0) = &9000
 STA toAddr
 LDA #&90
 STA toAddr+1

 LDX #&30               \ Set X = &30 to use as a page counter, so we copy
                        \ &4000-&6FFF to &9000-&BFFF

 LDY #0                 \ Set Y = 0 to use as a byte counter

.copy1

 LDA (fromAddr),Y       \ Copy the Y-th byte of fromAddr(1 0) to the Y-th byte
 STA (toAddr),Y         \ of toAddr(1 0)

 INY                    \ Increment the byte counter

 BNE copy1              \ Loop back until we have copied a whole page of bytes

 INC fromAddr+1         \ Increment the high bytes of fromAddr(1 0) and
 INC toAddr+1           \ toAddr(1 0) so they point to the next page in memory

 DEX                    \ Decrement the page counter

 BNE copy1              \ Loop back until we have copied X pages

 RTS                    \ Return from the subroutine

