\ ******************************************************************************
\
\       Name: rdrght
\       Type: Subroutine
\   Category: Save and load
\    Summary: Check that this is the correct track
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the RDRIGHT routine in Apple DOS 3.3.
\ It omits the code that saves the destination track, as this is not required.
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and track/sector list.
\
\ Elite uses different label names to the original DOS 3.3 source, but the code
\ is the same.
\
\ This code forms part of the RWTS ("read/write track-sector") layer from Apple
\ DOS, which was written by Randy Wigginton and Steve Wozniak. It implements the
\ low-level functions to read and write Apple disks, and is included in Elite so
\ the game can use the memory that's normally allocated to DOS for its own use.
\
\ ******************************************************************************

.rdrght

 LDY idfld+2            \ RDRIGHT  LDY TRACK      ; ON THE RIGHT TRACK?
 CPY track              \          CPY CURTRK
 BEQ rttrk              \          BEQ RTTRK      ; IF SO, GOOD
                        \ * NO, DRIVE WAS ON A DIFFERENT TRACK. TRY
                        \ * RESEEKING/RECALIBRATING FROM THIS TRACK
                        \          LDA CURTRK     ; PRESERVE DESTINATION TRACK
                        \          PHA
                        \          TYA
                        \          JSR SETTRK
                        \          PLA
 DEC seeks              \          DEC SEEKCNT    ; SHOULD WE RESEEK?
 BNE trytr6             \          BNE RESEEK     ; =>YES, RESEEK
 BEQ trytr5             \          BEQ RECAL      ; =>NO, RECALIBRATE!

