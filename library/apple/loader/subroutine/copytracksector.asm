\ ******************************************************************************
\
\       Name: CopyTrackSector
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy the track/sector list from the disk buffer to trackSector
\
\ ******************************************************************************

.CopyTrackSector

 LDY #0                 \ Set Y = 0 to use as a byte counter

.cpts1

 LDA buffer,Y           \ Copy the Y-th byte of buffer to the Y-th byte of
 STA trackSector,Y      \ trackSector

 INY                    \ Increment the byte counter

 BNE cpts1              \ Loop back until we have copied a whole page of data

 RTS                    \ Return from the subroutine

