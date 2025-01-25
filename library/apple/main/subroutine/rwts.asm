\ ******************************************************************************
\
\       Name: rwts
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read or write a specific sector
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the RWTS routine in Apple DOS 3.3.
\ It omits the code from the start of the routine that checks the command block
\ and slot number, as Elite doesn't use either of those features.
\
\ The original DOS 3.3 source code for this routine in is shown in the comments.
\ For detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner.
\
\ For details of the VTOC layout, catalog sector layout and file entry layout,
\ see chapter 4, "Diskette organisation".
\
\ Elite uses different label names to the original DOS 3.3 source, but the code
\ is the same.
\
\ This code forms part of the RWTS ("read/write track sector") layer from Apple
\ DOS, which was written by Randy Wigginton and Steve Wozniak. It implements the
\ low-level functions to read and write Apple disks, and is included in Elite so
\ the game can use the memory that's normally allocated to DOS for its own use.
\
\ ******************************************************************************

 LDA Q7L,X              \ SAMESLOT LDA Q7L,X      ; MAKE SURE IN READ MODE
 LDA Q6L,X              \          LDA Q6L,X
 LDY #8                 \          LDY #8         ; WE MAY HAFTA CHECK SEVERAL
                        \                           TIMES TO BE SURE

.rwts2                  \ CHKIFON  EQU *

 LDA Q6L,X              \          LDA Q6L,X      ; GET THE DATA
 PHA                    \          PHA            ; DELAY FOR DISK DATA TO
                        \                           CHANGE
 PLA                    \          PLA
 PHA                    \          PHA
 PLA                    \          PLA
                        \          STX SLOT

 CMP &100               \ This instruction replaces the STX SLOT instruction in
                        \ the original code
                        \
                        \ It has no effect as any changes to the flags will be
                        \ overridden by the next instruction, but the important
                        \ thing is that both STX SLOT and CMP &100 take four CPU
                        \ cycles, so this is effectively a way of commenting out
                        \ the original instruction without affecting the timings
                        \ that are so crucial to the workings of the RWTS code

 CMP Q6L,X              \          CMP Q6L,X      ; CHECK RUNNING HERE
 BNE rwts3              \          BNE ITISON     ; =>IT'S ON...
 DEY                    \          DEY            ; MAYBE WE DIDN'T CATCH IT
 BNE rwts2              \          BNE CHKIFON    ; SO WE'LL TRY AGAIN

                        \ A chunk of the original DOS is omitted here, from
                        \ ITISON to the start of OK, where we pick up the story
                        \ once again

.rwts3

 PHP                    \ Save the result of the above checks on the stack, so
                        \ we have the Z flag clear (BNE) if the disk is
                        \ spinning, or the Z flag set (BEQ) if the disk is not
                        \ spinning

 LDA mtron,X            \ Read the disk controller I/O soft switch at MOTORON
                        \ for slot X to turn the disk motor on

                        \ The following code omits the drive select code, as
                        \ Elite only supports drive 1

                        \ OK       ROR A          ; BY GOING INTO THE CARRY
                        \          BCC SD1        ; SELECT DRIVE 2 !
 LDA drv1en,X           \          LDA DRV1EN,X   ; ASSUME DRIVE 1 TO HIT
                        \          BCS DRVSEL     ; IF WRONG, ENABLE DRIVE 2
                        \                           INSTEAD
                        \
                        \ SD1      LDA DRV2EN,X
                        \
                        \ DRVSEL   EQU *
                        \          ROR DRIVNO     ; SAVE SELECTED DRIVE
                        \ *
                        \ * DRIVE SELECTED. IF MOTORING-UP,
                        \ *  WAIT BEFORE SEEKING...
                        \ *
 PLP                    \          PLP            ; WAS THE MOTOR
 PHP                    \          PHP            ; PREVIOUSLY OFF?
 BNE rwts5              \          BNE NOWAIT     ; =>NO, FORGET WAITING.
 LDY #7                 \          LDY #7         ; YES, DELAY 150 MS

.rwts4

 JSR armwat             \ SEEKW    JSR MSWAIT
 DEY                    \          DEY
 BNE rwts4              \          BNE SEEKW
 LDX slot16             \          LDX SLOT       ; RESTORE SLOT NUMBER

.rwts5                  \ NOWAIT   EQU *
                        \ *
                        \ * SEEK TO DESIRED TRACK...
                        \ *
                        \          LDY #4         ; SET TO IOBTRK
                        \          LDA (IOBPL),Y  ; GET DESIRED TRACK

 LDA track              \ We fetch the track number from the track variable
                        \ rather than the IOBPL block, as the Elite code just
                        \ stores values in variables instead

 JSR seek               \          JSR MYSEEK     ; SEEK!
                        \ *
                        \ * SEE IFMOTOR WAS ALREADY SPINNING.
                        \ *
 PLP                    \          PLP            ; WAS MOTOR ON?
 BNE trytrk             \          BNE TRYTRK     ; IF SO, DON'T DELAY, GET IT
                        \                           TODAY!
                        \ *
                        \ *  WAIT FOR MOTOR SPEED TO COME UP.
                        \ *
 LDY mtimeh             \          LDY MONTIME+1  ; IF MOTORTIME IS POSITIVE,
 BPL trytrk             \          BPL MOTORUP    ; THEN SEEK WASTED ENUFF TIME
                        \                           FOR US

.rwts6

 LDY #18                \ MOTOF    LDY #$12       ; DELAY 100 USEC PER COUNT

.rwts7

 DEY                    \ CONWAIT  DEY
 BNE rwts7              \          BNE CONWAIT
 INC mtimel             \          INC MONTIME
 BNE rwts6              \          BNE MOTOF
 INC mtimeh             \          INC MONTIME+1
 BNE rwts6              \          BNE MOTOF      ; COUNT UP TO $0000

