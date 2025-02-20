\ ******************************************************************************
\
\       Name: wbyte
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write one byte to disk
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This routine is identical to the WNIBL9 routine in Apple DOS 3.3.
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
\   wbyte2              Wait for seven cycles before writing instead of nine
\                       (this is WNIBL7 in the original source)
\
\   wbyte3              Write straight away without waiting (this is WNIBL in
\                       the original source)
\
\ ******************************************************************************

.wbyte

 CLC                    \ WNIBL9   CLC (2)        ; 9 CYCLES, THEN WRITE.

.wbyte2

 PHA                    \ WNIBL7   PHA (3)        ; 7 CYCLES, THEN WRITE.
 PLA                    \          PLA (4)

.wbyte3

 STA Q6H,X              \ WNIBL    STA Q6H,X      ; (5)  NIBL WRITE SUB.
 ORA Q6L,X              \          ORA Q6L,X      ; (4)  CLOBBERS ACC, NOT
                        \                                CARRY.
 RTS                    \          RTS

