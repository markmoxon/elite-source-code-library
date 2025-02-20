\ ******************************************************************************
\
\       Name: gettsl
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a file's track/sector list
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and track/sector list.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   buffer              The catalog sector for this file
\
\   Y                   The offset within the catalog sector for the relevant
\                       file entry
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   buffer              The track/sector list for the file
\
\   track               The track number of the file's data
\
\   sector              The sector number of the file's data
\
\ ******************************************************************************

.gettsl

 LDA buffer,Y           \ Set track to the track containing the track/sector
 STA track              \ list

 LDA buffer+1,Y         \ Set sector to the sector containing the track/sector
 STA sector             \ list

 JSR rsect              \ Read the track/sector list into the buffer

 LDY #&C                \ Set Y to offset &C, so it points to the track and
                        \ sector of first data sector in the track/sector list
                        \ we just loaded

 LDA buffer,Y           \ Set track to the track containing the file data
 STA track

 LDA buffer+1,Y         \ Set sector to the sector containing the file data
 STA sector

 RTS                    \ Return from the subroutine

