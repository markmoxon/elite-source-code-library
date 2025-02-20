\ ******************************************************************************
\
\       Name: rentry
\       Type: Subroutine
\   Category: Save and load
\    Summary: Search the disk catalog for an existing file or an empty file
\             entry
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
\   C flag              The type of search:
\
\                         * Clear = search the catalog for an existing file
\
\                         * Set = search the catalog for an empty file entry
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The result of the search:
\
\                         * Clear = file/entry found
\
\                         * Set = file/entry not found
\
\   Y                   The offset to the file entry in the catalog sector
\
\ ******************************************************************************

.rentry

 ROR atemp0             \ Store the C flag in bit 7 of atemp0, so we can check
                        \ it later

 JSR rvtoc              \ Read the VTOC sector into the buffer

                        \ We now work through the catalog sectors to look for
                        \ the existing file entry (if bit 7 of atemp0 is clear)
                        \ or an empty file empty (if bit 7 of atemp0 is set)

.rentr2

 LDA buffer+1           \ Set track to the track number of the next catalog
 STA track              \ sector from byte #1 of the VTOC

 LDA buffer+2           \ Set sector to the sector number of the next catalog
 STA sector             \ sector from byte #2 of the VTOC

 JSR rsect              \ Read the catalog sector into the buffer

 LDY #&B                \ Set Y to use as an index to the first file entry in
                        \ the catalog sector (as the file entries start at
                        \ offset &B in the catalog, with each entry taking up
                        \ 35 bytes)

.rentr3

 LDA buffer,Y           \ Set A to the first byte from the file entry, which
                        \ will either be the track number of the file, or 0 to
                        \ indicate an empty file entry, or &FF to indicate a
                        \ deleted file

 BIT atemp0             \ If bit 7 of atemp0 is clear then we are searching the
 BPL rentr4             \ catalog for an existing file entry, so jump to rentr4
                        \ to do this

                        \ If we get here then we are searching for an empty file
                        \ entry

 TAX                    \ If A = 0 then we have just found an empty file entry,
 BEQ rentr6             \ so jump to rentr6 to return from the subroutine with a
                        \ successful result

 CMP #&FF               \ If A = &FF then we have just found a deleted file
 BEQ rentr6             \ entry, so jump to rentr6 to return from the subroutine
                        \ with a successful result

 BNE rentr8             \ This file entry doesn't match our requirements, so
                        \ jump to rentr8 to try the next file entry in this
                        \ catalog sector

.rentr4

                        \ If we get here then we are searching for an existing
                        \ file entry

 TAX                    \ If A = 0 then we have just found an empty file entry,
 BEQ rentr9             \ which means we have not found a match for our file, so
                        \ jump to rentr9 to return from the subroutine with the
                        \ C flag set to indicate that we can't find the file

 CMP #&FF               \ If A = &FF then we have just found a deleted file
 BEQ rentr8             \ entry, which is not a match for our file, so jump to
                        \ rentr8 to try the next file entry in this catalog
                        \ sector

 TYA                    \ Store the file entry index in Y on the stack, so we
 PHA                    \ can retrieve it after the following loop

                        \ We now check the file entry to see if it matches the
                        \ filename in comnam

 LDX #0                 \ Set X = 0 to use as a character index for the filename
                        \ in the file entry

.rentr5

 LDA buffer+3,Y         \ Set A to the Y-th character from the filename in the
 AND #%01111111         \ file entry we are checking (the filename in a file
                        \ entry starts at byte #3)

 CMP comnam,X           \ If the character does not match the X-th character of
 BNE rentr7             \ comnam then the names don't match, to jump to rentr7
                        \ to try the next file entry in this catalog sector

 INY                    \ Increment the character index for the file entry

 INX                    \ Increment the character index for the filename we are
                        \ searching for

 CPX #30                \ Loop back until we have checked all 30 characters
 BNE rentr5

                        \ If we get here then all 30 characters of the filename
                        \ in the file entry match the filename in comnam, so we
                        \ have found the file entry we are looking for

 PLA                    \ Set Y to the file entry index that we stored on the
 TAY                    \ stack above, so it once again points to the entry we
                        \ are checking

.rentr6

 CLC                    \ Clear the C flag to indicate that we have found the
                        \ file entry we are looking for

 RTS                    \ Return from the subroutine

.rentr7

 PLA                    \ Set Y to the file entry index that we stored on the
 TAY                    \ stack above, so it once again points to the entry we
                        \ are checking

.rentr8

 TYA                    \ Set Y = Y + 35
 CLC                    \
 ADC #35                \ Each file entry in the catalog consists of 35 bytes,
 TAY                    \ so this increments Y to point to the next entry

 BNE rentr3             \ Loop back until we have reached the last file entry

 LDA buffer+1           \ Set track to the track number of the next catalog
                        \ sector from byte #1 of the VTOC

 BNE rentr2             \ If the next catalog sector is non-zero then loop back
                        \ to load and search this sector

                        \ Otherwise we have searched every catalog sector and we
                        \ haven't found what we're looking for, so fall through
                        \ into rentr9 to return from the subroutine with the C
                        \ flag set to indicate that the catalog is full

.rentr9

 SEC                    \ Clear the C flag to indicate that we have not found
                        \ the file entry we are looking for

 RTS                    \ Return from the subroutine

