\ ******************************************************************************
\
\       Name: rfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a commander file from a DOS disk into the buffer
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
\ Returns:
\
\   C flag              The result of the read:
\
\                         * Clear = file found and loaded into the comfil buffer
\
\                         * Set = file not found, in which case A = 5, which we
\                                 can pass to the diskerror routine to print a
\                                 "File not found" error
\
\   buffer              Contains the commander file
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   rfile3              Contains an RTS
\
\ ******************************************************************************

.rfile

 TSX                    \ Store the stack pointer in stkptr so we can restore it
 STX stkptr             \ if there's a disk error

 JSR findf              \ Search the disk catalog for a file with the filename
                        \ in comnam

 LDA #5                 \ If no file is found with this name then findf will
 BCS rfile3             \ set the C flag, so jump to rfile3 to return from the
                        \ subroutine with the C flag set and A = 5, to indicate
                        \ that the file cannot be found

 JSR gettsl             \ Get the track/sector list of the file and populate the
                        \ track and sector variables with the track and sector
                        \ of the file's contents, to pass to the call to rsect

 JSR rsect              \ Read the first sector of the file's data into the
                        \ buffer (this contains the whole commander file, as it
                        \ fits into one sector)

 LDY #0                 \ We now copy the loaded file into the comfil buffer,
                        \ so set a byte counter in Y

.rfile2

 LDA buffer+4,Y         \ Copy the Y-th byte from the disk buffer at buffer+4
 STA comfil,Y           \ to the Y-th byte of the comfil buffer

 INY                    \ Increment the byte counter

 CPY #comsiz            \ Loop back until we have copied the whole file (which
 BNE rfile2             \ contains comsiz bytes)

 CLC                    \ Clear the C flag to indicate that the file was found
                        \ and loaded

.rfile3

 RTS                    \ Return from the subroutine

