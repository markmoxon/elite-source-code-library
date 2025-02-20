\ ******************************************************************************
\
\       Name: rsect
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a specific sector from disk into the buffer
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
\   track               The track number
\
\   sector              The sector number
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   buffer              Contains the sector
\
\ ******************************************************************************

.rsect

 CLC                    \ Clear the C flag to denote that this is a read
                        \ operation (this value will be read throughout the
                        \ RWTS code that follows)

 BCC wsect2             \ Jump to wsect2 to read the specified sector

