\ ******************************************************************************
\
\       Name: LoadFile
\       Type: Subroutine
\   Category: Loader
\    Summary: Load a multi-sector file
\
\ ******************************************************************************

.LoadFile

 LDA #12                \ Set tslIndex = 12, so we can use this as an index into
 STA tslIndex           \ the track/sector list for the file we want to load,
                        \ starting with the index of the first track/sector pair
                        \ in byte #12

 JSR findf              \ Search the disk catalog for a file with the filename
                        \ in comnam

 BCS load4              \ If no file is found with this name then findf will
                        \ set the C flag, so jump to load4 to return from the
                        \ subroutine as the file cannot be found

 JSR gettsl             \ Get the track/sector list of the file and populate the
                        \ track and sector variables with the track and sector
                        \ of the file's contents, to pass to the call to rsect

 JSR CopyTrackSector    \ Copy the track/sector list from the buffer into
                        \ trackSector so we can work our way through it to load
                        \ the file one sector at a time

.load1

 JSR rsect              \ Read the first sector of the file's data into the
                        \ buffer (or the next sector if we loop back from below)

 LDY skipBytes          \ Set Y to the number of bytes to skip from the start of
                        \ the file, so we can use it as a starting index into
                        \ the first sector that we copy

 LDX #0                 \ Set X = 0 to act as a byte index into the destination
                        \ address for the file

.load2

 LDA buffer,Y           \ Set A to the Y-th byte in the buffer

.loadAddr

 STA &4000,X            \ And copy it to the X-th byte of the load address,
                        \ which by this point has been modified to the correct
                        \ load address by the SetLoadVariables1 or
                        \ SetLoadVariables2 routine

 JSR DecrementFileSize  \ Decrement the file size in fileSize(1 0) by 1 as we
                        \ have just loaded one more byte of the file

 BMI load4              \ If the result is negative then we have copied all
                        \ fileSize(1 0) bytes, so jump to load4 to return from
                        \ the subroutine

 INX                    \ Increment the destination index in X

 INY                    \ Increment the source index in Y

 BNE load2              \ Loop back until we have reached the end of the page
                        \ page in the source index

 INC loadAddr+2         \ Update the load address as follows:
 LDA loadAddr+1         \
 SEC                    \   loadAddr = loadAddr + 256 - skipBytes
 SBC skipBytes          \
 STA loadAddr+1         \ This makes sure that loadAddr points to the correct
 LDA loadAddr+2         \ load address for the next sector, as we just loaded a
 SBC #0                 \ sector's worth of bytes (256) and skipped the first
 STA loadAddr+2         \ skipBytes bytes

 LDA skipBytes          \ Set skipBytes = 0 so we don't skip any bytes from the
 BEQ load3              \ remaining sectors (as we only want to skip bytes from
 LDA #0                 \ the first sector)
 STA skipBytes

.load3

 INC tslIndex           \ Set tslIndex = tslIndex + 2 to point to the next track
 INC tslIndex           \ and sector pair in the track/sector list

 LDY tslIndex           \ Set track to the track number from the next pair in
 LDA trackSector,Y      \ the track/sector list
 STA track

 LDA trackSector+1,Y    \ Set sector to the sector number from the next pair in
 STA sector             \ the track/sector list

 BNE load1              \ If either the track or sector number is non-zero, loop
 LDA track              \ back to load1 to load the next sector
 BNE load1

.load4

 RTS                    \ Return from the subroutine

