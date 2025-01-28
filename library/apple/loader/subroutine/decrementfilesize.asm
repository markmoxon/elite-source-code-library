\ ******************************************************************************
\
\       Name: DecrementFileSize
\       Type: Subroutine
\   Category: Loader
\    Summary: Decrement the file size in fileSize(1 0) by 1
\
\ ******************************************************************************

.DecrementFileSize

 LDA fileSize           \ Set fileSize(1 0) = fileSize(1 0) - 1
 SEC
 SBC #1
 STA fileSize
 LDA fileSize+1
 SBC #0
 STA fileSize+1

 RTS                    \ Return from the subroutine

