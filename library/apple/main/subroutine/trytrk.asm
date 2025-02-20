\ ******************************************************************************
\
\       Name: trytrk
\       Type: Subroutine
\   Category: Save and load
\    Summary: Try finding a specific track on the disk
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the TRYTRK routine in Apple DOS 3.3.
\ It omits the code from the start of the routine that checks for the format
\ command, as this is not required.
\
\ The original DOS 3.3 source code for this routine in is shown in the comments.
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
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   trytr4              Entry point for track errors, so we can try reading it
\                       again (must have the status flags on the stack with the
\                       C flag set)
\
\   trytr5              Re-entry point for the loop from the rdrght subroutine,
\                       for when we need to re-calibrate
\
\   trytr6              Re-entry point for the loop from the rdrght subroutine,
\                       for when we need to re-seek
\
\ ******************************************************************************

.trytrk

                        \ TRYTRK   EQU *
                        \          LDY #$0C
                        \          LDA (IOBPL),Y  ; GET COMMAND CODE #
                        \          BEQ GALLDONE   ; IF NULL COMMAND, GO HOME TO
                        \                           BED.
                        \          CMP #$04       ; FORMAT THE DISK?
                        \          BEQ FORMDSK    ; ALLRIGHT,ALLRIGHT, I WILL...
                        \          ROR A          ; SET CARRY=1 FOR READ, 0 FOR
                        \                           WRITE
                        \          PHP            ; AND SAVE THAT
                        \          BCS TRYTRK2    ; MUST PRENIBBLIZE FOR WRITE.

 PLP                    \ Instead of the above checks, which we don't need to do
 PHP                    \ as we don't want to format the disk, we can simply
 BCC trytr2             \ fetch the read/write status into the C flag from the
                        \ stack, and if the C flag is clear then we are reading
                        \ a sector, so skip the following instruction as we
                        \ only need to call prenib if we are writing

 JSR prenib             \          JSR PRENIB16

.trytr2

 LDY #48                \ TRYTRK2  LDY #$30       ; ONLY 48 RETRIES OF ANY KIND.
 STY ztemp2             \          STY RETRYCNT

.trytr3

 LDX slot16             \ TRYADR   LDX SLOT       ; GET SLOT NUM INTO X-REG
 JSR rdaddr             \          JSR RDADR16    ; READ NEXT ADDRESS FIELD
 BCC rdrght             \          BCC RDRIGHT    ; IF READ IT RIGHT, HURRAH!

.trytr4

 DEC ztemp2             \ TRYADR2  DEC RETRYCNT   ; ANOTHER MISTAEK!!
 BPL trytr3             \          BPL TRYADR     ; WELL, LET IT GO THIS TIME.,
                        \ *
                        \ * RRRRRECALIBRATE !!!!
                        \ *

.trytr5                 \ RECAL    EQU *
                        \          LDA CURTRK
                        \          PHA            ; SAVE TRACK WE REALLY WANT
                        \          LDA #$60       ; RECALIBRATE ALL OVER AGAIN!
                        \          JSR SETTRK     ; PRETEND TO BE ON TRACK 96
 DEC recals             \          DEC RECALCNT   ; ONCE TOO MANY??
 BEQ drverr             \          BEQ DRVERR     ; TRIED TO RECALIBRATE TOO
                        \                           MANY TIMES, ERROR!
 LDA #4                 \          LDA #MAXSEEKS  ; RESET THE
 STA seeks              \          STA SEEKCNT    ; SEEK COUNTER

 LDA #&60               \ The instructions LDA #$60 and JSR SETTRK above have
 STA curtrk             \ been replaced by these two, which do the same thing
                        \ but without the more generalised code of the original

 LDA #0                 \          LDA #$00
 JSR seek               \          JSR MYSEEK     ; MOVE TO TRACK 00
                        \          PLA

                        \ The first two instructions at RECAL (LDA CURTRK and
                        \ PHA) and the PLA instruction above have been replaced
                        \ by the LDA track instruction below, which do the same
                        \ thing

.trytr6

 LDA track              \ Fetch the track number into A

 JSR seek               \ RESEEK   JSR MYSEEK     ; GO TO CORRECT TRACK THIS
                        \                           TIME!
 JMP trytr2             \          JMP TRYTRK2    ; LOOP BACK, TRY AGAIN ON THIS
                        \                           TRACK

