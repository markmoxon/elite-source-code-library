\ ******************************************************************************
\
\       Name: rtable
\       Type: Variable
\   Category: Save and load
\    Summary: 64 disk nibbles of "6-and-2" Read Translate Table
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This table is identical to the table at address &3A96 in Apple DOS 3.3. The
\ table doesn't have a label in the original source.
\
\ The original DOS 3.3 source code for this table in is shown in the comments.
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

.rtable

 EQUD &99980100         \          DFB $00,$01,$98
 EQUD &049C0302         \          DFB $99,$02,$03
 EQUD &A1A00605         \          DFB $9C,$04,$05
 EQUD &A5A4A3A2         \          DFB $06,$A0,$A1
 EQUD &A9A80807         \          DFB $A2,$A3,$A4
 EQUD &0B0A09AA         \          DFB $A5,$07,$08
 EQUD &B1B00D0C         \          DFB $A8,$A9,$AA
 EQUD &11100F0E         \          DFB $09,$0A,$0B
 EQUD &14B81312         \          DFB $0C,$0D,$B0
 EQUD &18171615         \          DFB $B1,$0E,$0F
 EQUD &C1C01A19         \          DFB $10,$11,$12
 EQUD &C5C4C3C2         \          DFB $13,$B8,$14
 EQUD &C9C8C7C6         \          DFB $15,$16,$17
 EQUD &1CCC1BCA         \          DFB $18,$19,$1A
 EQUD &D1D01E1D         \          DFB $C0,$C1,$C2
 EQUD &D5D41FD2         \          DFB $C3,$C4,$C5
 EQUD &22D82120         \          DFB $C6,$C7,$C8
 EQUD &26252423         \          DFB $C9,$CA,$1B
 EQUD &E1E02827         \          DFB $CC,$1C,$1D
 EQUD &29E4E3E2         \          DFB $1E,$D0,$D1
 EQUD &2CE82B2A         \          DFB $D2,$1F,$D4
 EQUD &302F2E2D         \          DFB $D5,$20,$21
 EQUD &F1F03231         \          DFB $D8,$22,$23
 EQUD &36353433         \          DFB $24,$25,$26
 EQUD &39F83837         \          DFB $27,$28,$E0
 EQUD &3D3C3B3A         \          DFB $E1,$E2,$E3
 EQUW &3F3E             \          DFB $E4,$29,$2A
                        \          DFB $2B,$E8,$2C
                        \          DFB $2D,$2E,$2F
                        \          DFB $30,$31,$32
                        \          DFB $F0,$F1,$33
                        \          DFB $34,$35,$36
                        \          DFB $37,$38,$F8
                        \          DFB $39,$3A,$3B
                        \          DFB $3C,$3D,$3E
                        \          DFB $3F

