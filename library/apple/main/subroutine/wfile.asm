\ ******************************************************************************
\
\       Name: wfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a commander file from the buffer to a DOS disk
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
\   buffer              Contains the commander file
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The result of the write:
\
\                         * Clear = file written
\
\                         * Set = file not written, with the error number in A,
\                                 which we can pass to the diskerror routine to
\                                 print the error message:
\
\                           * A = 2 = Disk full
\
\                           * A = 3 = Catalog full
\
\ ******************************************************************************

.wfile

 JSR MUTILATE           \ Encrypt the commander file in the buffer at comfil

 TSX                    \ Store the stack pointer in stkptr so we can restore it
 STX stkptr             \ if there's a disk error

 JSR findf              \ Search the disk catalog for a file with the filename
                        \ in comnam

 BCC oldfil             \ If a file is found with this name then findf will
                        \ return with the C flag clear, so jump to oldfil if
                        \ this is the case so we overwrite the existing file

.newfil

                        \ If we get here then this file does not already exist
                        \ on the disk, so we need to save a new one

 JSR isfull             \ Check the disk to ensure there are least two free
                        \ sectors, returning one sector for the commander file's
                        \ track/sector list and another sector for the commander
                        \ file's contents

 LDA #2                 \ If there are not enough free sectors on the disk then
 BCS rfile3             \ isfull will set the C flag, so jump to rfile3 to
                        \ return from the subroutine with the C flag set and
                        \ A = 2, to indicate that the disk is full

 JSR finde              \ Search the disk catalog for an empty file entry that
                        \ we can use for the new file, loading the catalog
                        \ sector into the buffer and setting Y to the offset of
                        \ the start of the empty file entry (if there is one)

 LDA #3                 \ If there is no empty file entry in the disk catalog
 BCS rfile3             \ then finde will set the C flag, so jump to rfile3 to
                        \ return from the subroutine with the C flag set and
                        \ A = 3, to indicate that the catalog is full

                        \ We have two free sectors and there is room in the disk
                        \ catalog for a new file, so we can now write the file
                        \
                        \ We do this in three stages:
                        \
                        \   * Add the new file to the disk catalog
                        \
                        \   * Write the track/sector list for the new file
                        \
                        \   * Write the file contents (which all fits into one
                        \     sector)
                        \
                        \ We start by adding the new file to the disk catalog,
                        \ which involves populating the empty entry in the VTOC
                        \ and adding a file entry for this file to the catalog
                        \ sector
                        \
                        \ The call to finde loaded the VTOC into the disk buffer
                        \ at buffer, and the empty file entry is at offset Y, so
                        \ that's what we need to populate

 LDA tsltrk             \ Copy the track field from the track/sector list into
 STA buffer,Y           \ the file entry at byte #0

 LDA tslsct             \ Copy the sector field from the track/sector list into
 STA buffer+1,Y         \ the file entry at byte #1

 LDA #4                 \ Set the file type to 4, for a BINARY file, at byte #2
 STA buffer+2,Y         \ in the file entry

 LDA #2                 \ Set the sector count to 2, stored as a 16-bit value
 STA buffer+&21,Y       \ in bytes (&22 &21) of the file entry
 LDA #0
 STA buffer+&22,Y

 TAX                    \ We now copy the filename from comnam to byte #3 in
                        \ the file entry for this file, so set X = 0 to use as a
                        \ byte counter

.newfl2

 LDA comnam,X           \ Copy the X-th character from the filename into the
 ORA #&80               \ file entry, starting at byte #3 (which is where the
 STA buffer+3,Y         \ filename is stored in the entry)

 INY                    \ Increment the offset index in Y to point to the next
                        \ byte in the file entry

 INX                    \ Increment the byte counter in X to point to the next
                        \ character in the filename

 CPX #30                \ Loop back to copy the next character until we have
 BNE newfl2             \ copied all 30 characters in the filename

 JSR wsect              \ Write the updated catalog sector to the disk

 JSR isfull             \ Check the disk to ensure there are least two free
                        \ sectors, returning one sector for the commander file's
                        \ track/sector list and another sector for the commander
                        \ file's contents
                        \
                        \ We do this so the VTOC gets loaded and updated once
                        \ again (as we corrupted it above when updating the
                        \ catalog sector), and because isfull doesn't write the
                        \ updated VTOC to disk, we do that now

 JSR wsect              \ Write the updated VTOC sector to the disk

.newfl3

                        \ Next we create the track/sector list for the new file

 LDA #0                 \ First we zero the buffer so we can use it to build the
                        \ track/sector list, so set A = 0 to use as a reset
                        \ value

 TAY                    \ Set Y = 0 to use as a byte counter

.newfl4

 STA buffer,Y           \ Zero the Y-th byte in the buffer

 INY                    \ Increment the byte counter

 BNE newfl4             \ Loop back until we have zeroed all 256 bytes

 LDA filtrk             \ Set byte #12 of the track/sector list to the track
 STA buffer+12          \ number for the file contents, which the call to isfull
                        \ put into filtrk

 LDA filsct             \ Set byte #13 of the track/sector list to the sector
 STA buffer+13          \ number for the file contents, which the call to isfull
                        \ put into filsct

 LDA tsltrk             \ Set the track variable to the track number of the
 STA track              \ track/sector list, which the call to isfull put into
                        \ tsltrk, so we can pass this to the wsect routine

 LDA tslsct             \ Set the sector variable to the sector number of the
 STA sector             \ track/sector list, which the call to isfull put into
                        \ tslsct, so we can pass this to the wsect routine

 JSR wsect              \ Write the contents of the buffer to the specified
                        \ track and sector, to write the track/sector list for
                        \ the commander file to disk

                        \ And finally we write the file contents

 LDA filtrk             \ Set the track variable to the track number of the
 STA track              \ file contents, which the call to isfull put into
                        \ filtrk, so we can pass this to the wsect routine

 LDA filsct             \ Set the sector variable to the sector number of the
 STA sector             \ file contents, which the call to isfull put into
                        \ filsct, so we can pass this to the wsect routine

 BPL oldfl2             \ Jump to oldfl2 to write the file contents to the disk
                        \ using the track and sector we just specified (this BPL
                        \ if effectively a JMP as the sector number in A is
                        \ always less than 128)

.oldfil

                        \ If we get here then this file already exists on the
                        \ disk, so we need to overwrite it with the new file

 JSR gettsl             \ Get the track/sector list of the file and populate the
                        \ track and sector variables with the track and sector
                        \ of the file's contents, to pass to the call to wsect

.oldfl2

 LDY #0                 \ We first copy the commander file we want to save from
                        \ the comfil buffer to the disk buffer, so set a byte
                        \ counter in Y

.oldfl3

 LDA comfil,Y           \ Copy the Y-th byte from the commander file at comfil
 STA buffer+4,Y         \ to the Y-th byte of the disk buffer at buffer+4

 INY                    \ Increment the byte counter

 CPY #comsiz            \ Loop back until we have copied the whole file (which
 BNE oldfl3             \ contains comsiz bytes)

 JMP wsect              \ Write the first sector of the commander file, which
                        \ will write the whole file as it fits into one sector,
                        \ and return from the subroutine using a tail call

