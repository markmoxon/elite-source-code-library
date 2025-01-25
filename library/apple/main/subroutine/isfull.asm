\ ******************************************************************************
\
\       Name: isfull
\       Type: Subroutine
\   Category: Save and load
\    Summary: Check the disk to ensure there are least two free sectors, one for
\             the file's track/sector list and one for the file's contents
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
\   C flag              The result of the check:
\
\                         * Clear = two free sectors found
\
\                         * Set = no free sectors found (i.e. the disk is full)
\
\   tsltrk              The track for the file's track/sector list
\
\   tslsct              The sector for the file's track/sector list
\
\   filtrk              The track for the file's contents
\
\   filsct              The sector for the file's contents
\
\ ******************************************************************************

.isfull

 JSR rvtoc              \ Read the VTOC sector into the buffer

 JSR getsct             \ Allocate a free sector in the VTOL, that we can use
                        \ for the track/sector list, and return the track number
                        \ in X and the sector number in Y

 BCS isful2             \ If we the call to getsct couldn't find a free sector,
                        \ then it will have set the C flag, so jump to isful2 to
                        \ return this from the subroutine to indicate that the
                        \ catalog is full

 STX tsltrk             \ Store the track number containing the free sector in
                        \ tsltrk

 STY tslsct             \ Store the free sector number in tslsct

 JSR getsct             \ Allocate a free sector in the VTOL, that we can use
                        \ for the file contents, and return the track number
                        \ in X and the sector number in Y
                        \
                        \ If there is not enough space, this will set the C
                        \ flag, which we will return from the subroutine to
                        \ indicate that the catalog is full

 STX filtrk             \ Store the track number containing the free sector in
                        \ filtrk

 STY filsct             \ Store the free sector number in filsct

.isful2

 RTS                    \ Return from the subroutine

