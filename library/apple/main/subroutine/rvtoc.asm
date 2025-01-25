\ ******************************************************************************
\
\       Name: rvtoc
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read the VTOC sector into the buffer
\
\ ------------------------------------------------------------------------------
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and file/track list.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   buffer              Contains the VTOC sector
\
\ ******************************************************************************

.rvtoc

 LDA #17                \ Set the track number to 17, which is where the VTOC is
 STA track              \ stored on the disk

 LDA #0                 \ Set the sector number to 0, which is where the VTOC is
 STA sector             \ stored on the disk

                        \ Fall through into rsect to read sector 0 in track 17,
                        \ so we read the VTOC sector from the disk into the
                        \ buffer

