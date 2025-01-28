\ ******************************************************************************
\
\       Name: SetLoadVariables1
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the file load variables for loading the SCRN file
\
\ ******************************************************************************

.SetLoadVariables1

 LDA #4                 \ Set skipBytes = 4 so we skip the first four bytes of
 STA skipBytes          \ the file (as these contain the program start address
                        \ and file length)

 LDA #&80               \ Set fileSize(1 0) = &0880
 STA fileSize
 LDA #&08
 STA fileSize+1

 LDA #0                 \ Set trackSector = 0 (though this appears to have no
 STA trackSector        \ effect, as it isn't checked anywhere and the first
                        \ byte of the track/sector list is unused)

 LDA #&00               \ Modify the instruction at loadAddr to STA &0200,X
 STA loadAddr+1
 LDA #&02
 STA loadAddr+2

 RTS                    \ Return from the subroutine

