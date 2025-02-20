\ ******************************************************************************
\
\       Name: prenib
\       Type: Subroutine
\   Category: Save and load
\    Summary: Convert 256 8-bit bytes in buffer into 342 6-bit nibbles in buffr2
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This routine is identical to the PRENIB16 routine in Apple DOS 3.3.
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

.prenib

 LDX #0                 \ PRENIB16 LDX #$0        ; START NBUF2 INDEX. CHANGED
                        \                           BY WOZ
 LDY #2                 \          LDY #2         ; START USER BUF INDEX.
                        \                           CHANGED BY WOZ.

.prenb2

 DEY                    \ PRENIB1  DEY NEXT       ; USER BYTE.
 LDA buffer,Y           \          LDA (BUF),Y
 LSR A                  \          LSR A          ; SHIFT TWO BITS OF
 ROL buffr2+256,X       \          ROL NBUF2,X    ; CURRENT USER BYTE
 LSR A                  \          LSR A          ; INTO CURRENT NBUF2
 ROL buffr2+256,X       \          ROL NBUF2,X    ; BYTE.
 STA buffr2,Y           \          STA NBUF1,Y    ; (6 BITS LEFT).
 INX                    \          INX            ; FROM 0 TO $55.
 CPX #&56               \          CPX #$56
 BCC prenb2             \          BCC PRENIB1    ; BR IF NO WRAPAROUND.
 LDX #0                 \          LDX #0         ; RESET NBUF2 INDEX.
 TYA                    \          TYA            ; USER BUF INDEX.
 BNE prenb2             \          BNE PRENIB1    ; (DONE IF ZERO)
 LDX #&55               \          LDX #$55       ; NBUF2 IDX $55 TO 0.

.prenb3

 LDA buffr2+256,X       \ PRENIB2  LDA NBUF2,X
 AND #&3F               \          AND #$3F       ; STRIP EACH BYTE
 STA buffr2+256,X       \          STA NBUF2,X    ; OF NBUF2 TO 6 BITS.
 DEX                    \          DEX
 BPL prenb3             \          BPL PRENIB2    ; LOOP UNTIL X NEG.
 RTS                    \          RTS            ; RETURN.

