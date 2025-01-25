\ ******************************************************************************
\
\       Name: getsct
\       Type: Subroutine
\   Category: Save and load
\    Summary: Analyse the VTOC sector to allocate one free sector
\
\ ------------------------------------------------------------------------------
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and file/track list.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   buffer              The VTOC sector for this disk
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The result of the check:
\
\                         * Clear = free sector found
\
\                         * Set = no free sectors found (i.e. the disk is full)
\
\   X                   The track number containing the free sector
\
\   Y                   The free sector number
\
\ ******************************************************************************

.getsct

 LDA #0                 \ Set ztemp0 = 0 to denote that we are starting this
 STA ztemp0             \ search in the outer half of the disk from track 16
                        \ down to track 0

 BEQ getsc4             \ Jump into the loop below at getsc4 with A = 0, so we
                        \ start the search at the last track number that we
                        \ checked, which is in fretrk

.getsc3

 LDA dirtrk             \ Set A to the direction we are moving in our search for
                        \ a free sector (-1 or +1)

.getsc4

 CLC                    \ Add the direction in A to the last allocated track so
 ADC fretrk             \ we move in the direction in A
                        \
                        \ Or, if we just started searching with A = 0, we check
                        \ the last allocated track, as it might not have been
                        \ used last time and might still be free
                        \
                        \ In either case, A now contains the next track to check
                        \ for a free sector

 BEQ getsc5             \ If we have reached track 0, jump to getsc5

 CMP tracks             \ If A is less than the number of tracks on the disc
 BCC getsc7             \ then we haven't reached the highest numbered track
                        \ yet, so jump to getsc7 to check this track for a free
                        \ sector

 LDA #&FF               \ Otherwise we have reached the highest numbered track,
                        \ so set A = -1 so we start searching from track 16 down
                        \ to track 0

 BNE getsc6             \ Jump to getsc6 to set the direction to -1 and start
                        \ searching from track 16 down to track 0 (this BNE is
                        \ effectively a JMP as A is always non-zero)

.getsc5

 LDA ztemp0             \ If ztemp0 is non-zero then we have already searched
 BNE getscB             \ the disk from track 18 up to track 34, and we jumped
                        \ here when we finished searching track 16 down to track
                        \ 0, so we have searched the whole disk and haven't
                        \ found a free sector, so jump to getscB to return from
                        \ the subroutine with a disk full error

 LDA #1                 \ Otherwise we have not already searched from track 18
                        \ up to track 34, so set A = +1 so we start searching
                        \ from track 18 up to track 34

 STA ztemp0             \ Set ztemp0 = 1 to record that we are now searching the
                        \ half of the disk track 18 up to track 34

.getsc6

 STA dirtrk             \ Set the search direction to A, so it's now -1 or +1

 CLC                    \ Set A = A + 17, so A is now the track next to the VTOC
 ADC #17                \ track in the direction we want to search (the VTOC is
                        \ always in track 17)
                        \
                        \ So this is the track to start searching from, heading
                        \ in the new direction in dirtrk

.getsc7

 STA fretrk             \ Store the number of the track we are checking for a
                        \ free sector in fretrk

                        \ We now search the bitmap of free sectors for the track
                        \ in A, which is part of the VTOC and is therefore in
                        \ buffer
                        \
                        \ The bitmaps for each track are stored at byte &38 (for
                        \ track 0) onwards, with four bitmap bytes per track,
                        \ though only the first two bytes contain bitmap data
                        \
                        \ The bitmap variable points to byte #56 (&38) of the
                        \ buffer where we loaded the VTOC, so it points to the
                        \ first bitmap for track 0

 ASL A                  \ Set Y = A * 4
 ASL A                  \
 TAY                    \ So we can use Y as an index into the bitmap of free
                        \ sectors in the buffer, so the bitmap for track Y is
                        \ at bitmap + Y

 LDX #16                \ Set X = 16 to denote that we are searching the first
                        \ byte of the bitmap

 LDA bitmap,Y           \ Set A to the first byte of the bitmap for the track
                        \ we are checking

 BNE getsc8             \ If A is non-zero then there is a non-zero bit in the
                        \ bitmap, which indicates a free sector, so jump to
                        \ getsc8 to convert this into a sector number

 INY                    \ Increment Y to point to the next byte in the bitmap
                        \ of free sectors

 LDX #8                 \ Set X = 8 to denote that we are searching the second
                        \ byte of the bitmap

 LDA bitmap,Y           \ Set A to the second byte of the bitmap for the track
                        \ we are checking

 BEQ getsc3             \ If A is zero then every sector is occupied in the
                        \ bitmap, so loop back getsc3 to move on to the next
                        \ track, as there are no free sectors in this one

.getsc8

                        \ If we get here then we have found a free sector in
                        \ the bitmap for this track, so we need to convert this
                        \ into a sector number
                        \
                        \ We do this by looping through the bitmap byte in A
                        \ until we find a set bit to indicate a free sector

 STX ztemp0             \ Store X in ztemp0, so it is 16 if we found a free
                        \ sector in the first bitmap byte, or 8 if we found a
                        \ free sector in the second bitmap byte
                        \
                        \ So ztemp0 is the sector number that corresponds to
                        \ bit 7 in the relevant byte, as the first byte covers
                        \ sectors 8 to 15 (bit 0 to 7), and the second byte
                        \ covers sectors 0 to 7 (bit 0 to 7)

 LDX #0                 \ Set a counter in X to keep track of the position of
                        \ the bit we are currently checking

.getsc9

 INX                    \ Increment the bit position in X

 DEC ztemp0             \ Decrement the sector number in ztemp0

 ROL A                  \ Set the C flag to the next bit from the bitmap byte

 BCC getsc9             \ Loop back to getsc9 until we shift a 1 out of the
                        \ bitmap byte, which indicates a free sector

                        \ We now change this 1 to a 0 and shift all the other
                        \ bits in the bitmap back to their original positions

 CLC                    \ Clear the C flag so the first rotation in the
                        \ following loop will replace the 1 we just found with a
                        \ 0, to indicate that it is no longer free

.getscA

 ROR A                  \ Rotate the bits back into A again

 DEX                    \ Decrement the position counter in X

 BNE getscA             \ Loop back until we have rotated all the bits back into
                        \ the bitmap, with the 1 changed to a 0

 STA bitmap,Y           \ update VTOC

 LDX fretrk             \ Set X to the track number where we found the free
                        \ sector, which we stored in fretrk, so we can return it
                        \ from the subroutine

 LDY ztemp0             \ Set X to the number of the free sector in ztemp0, so
                        \ we can return it from the subroutine

 CLC                    \ Clear the C flag to indicate that we have successfully
                        \ found a free sector

 RTS                    \ Return from the subroutine

.getscB

 SEC                    \ Clear the C flag to indicate that we have not found
                        \ a free sector and the disk is full

 RTS                    \ Return from the subroutine

