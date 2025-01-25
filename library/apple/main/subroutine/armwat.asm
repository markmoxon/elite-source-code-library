\ ******************************************************************************
\
\       Name: armwat
\       Type: Subroutine
\   Category: Save and load
\    Summary: Implement the arm move delay
\
\ ------------------------------------------------------------------------------
\
\ This routine is identical to the MSWAIT routine in Apple DOS 3.3.
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

.armwat

 LDX #17                \ MSWAIT   LDX #$11

.armwt2

 DEX                    \ MSW1     DEX DELAY      ; 86 USEC.
 BNE armwt2             \          BNE MSW1
 INC mtimel             \          INC MONTIMEL
 BNE armwt3             \          BNE MSW2       ; DOUBLE-BYTE
 INC mtimeh             \          INC MONTIMEH   ; INCREMENT.

.armwt3

 SEC                    \ MSW2     SEC
 SBC #1                 \          SBC #$1        ; DONE 'N' INTERVALS?
 BNE armwat             \          BNE MSWAIT     ; (A-REG COUNTS)
 RTS                    \          RTS

