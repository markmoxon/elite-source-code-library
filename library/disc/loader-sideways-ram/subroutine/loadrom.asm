\ ******************************************************************************
\
\       Name: LoadRom
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy a pre-generated ship blueprints ROM image from address &3400
\             into sideways RAM
\
\ ******************************************************************************

.LoadRom

 LDA &F4                \ Switch to the ROM bank in X, storing the current ROM
 PHA                    \ bank on the stack
 STX &F4
 STX VIA+&30

 LDA #&34               \ Modify the address at lrom1 below so we copy the ROM
 STA lrom1+2            \ image from &3400

 LDA #&80               \ Modify the address at lrom2 below so we copy the ROM
 STA lrom2+2            \ image to sideways RAM at &8000

 LDY #0                 \ Set Y to use as a counter for each byte that is copied

 LDX #&40               \ Set X as a page counter for each page of 256 bytes
                        \ that is copied

.lrom1

 LDA &3400,Y            \ Copy the Y-th byte from &3400

.lrom2

 STA &8000,Y            \ To the Y-th byte of &8000

 INY                    \ Increment the byte counter

 BNE lrom1              \ Loop back until we have copied a whole page of 256
                        \ bytes

 INC lrom1+2            \ Modify the address at lrom1 to increment the source
                        \ address

 INC lrom2+2            \ Modify the address at lrom2 to increment the
                        \ destination address

 DEX                    \ Decrement the page counter

 BNE lrom1              \ Loop back until we have copied all &40 pages of the
                        \ ROM image

 LDX &F4                \ Update the paged ROM type table in MOS workspace with
 LDA &8000+6            \ the type of the copied ROM, which is in byte #6 of the
 STA ROMTYPE,X          \ ROM header

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine

