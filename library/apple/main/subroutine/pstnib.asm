\ ******************************************************************************
\
\       Name: pstnib
\       Type: Subroutine
\   Category: Save and load
\    Summary: Convert 342 6-bit nibbles in buffr2 into 256 8-bit bytes in buffer
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the POSTNB16 routine in Apple DOS 3.3. The
\ CPY T0 instruction from the original source is omitted as we only need to
\ check whether the byte counter in Y has reached zero.
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and file/track list.
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

.pstnib

 LDY #0                 \ POSTNB16 LDY #0         ; USER DATA BUF IDX.

.pstnb2

 LDX #&56               \ POST1    LDX #$56       ; INIT NBUF2 INDEX.

.pstnb3

 DEX                    \ POST2    DEX NBUF       ; IDX $55 TO $0.
 BMI pstnb2             \          BMI POST1      ; WRAPAROUND IF NEG.
 LDA buffr2,Y           \          LDA NBUF1,Y
 LSR buffr2+256,X       \          LSR NBUF2,X    ; SHIFT 2 BITS FROM
 ROL A                  \          ROL A          ; CURRENT NBUF2 NIBL
 LSR buffr2+256,X       \          LSR NBUF2,X    ; INTO CURRENT NBUF1
 ROL A                  \          ROL A          ; NIBL.
 STA buffer,Y           \          STA (BUF),Y    ; BYTE OF USER DATA.
 INY                    \          INY NEXT       ; USER BYTE.
                        \          CPY T0         ; DONE IF EQUAL T0.
 BNE pstnb3             \          BNE POST2
 RTS                    \          RTS RETURN.

