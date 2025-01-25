\ ******************************************************************************
\
\       Name: scttab
\       Type: Variable
\   Category: Save and load
\    Summary: Lookup table to translate logical (requested) sector number to
\             physical sector number
\
\ ------------------------------------------------------------------------------
\
\ This table is identical to the INTRLEAV table in Apple DOS 3.3.
\
\ The original DOS 3.3 source code for this table in is shown in the comments.
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

.scttab                 \ INTRLEAV EQU *

 EQUD &090B0D00         \          DFB $00,$0D,$0B,$09
 EQUD &01030507         \          DFB $07,$05,$03,$01
 EQUD &080A0C0E         \          DFB $0E,$0C,$0A,$08
 EQUD &0F020406         \          DFB $06,$04,$02,$0F

