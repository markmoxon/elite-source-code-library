\ ******************************************************************************
\
\       Name: read
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a sector's worth of data into the buffr2 buffer
\
\ ------------------------------------------------------------------------------
\
\ This routine is identical to the READ16 routine in Apple DOS 3.3.
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

.read

 LDY #32                \ READ16   LDY #$20       ; 'MUST FIND' COUNT.

.read2

 DEY                    \ RSYNC    DEY IF         ; CAN'T FIND MARKS
 BEQ readE              \          BEQ RDERR      ; THEN EXIT WITH CARRY SET.

.read3

 LDA Q6L,X              \ READ1    LDA Q6L,X      ; READ NIBL.
 BPL read3              \          BPL READ1      ; *** NO PAGE CROSS! ***

.read4

 EOR #&D5               \ RSYNC1   EOR #$D5       ; DATA MARK 1?
 BNE read2              \          BNE RSYNC      ; LOOP IF NOT.
 NOP                    \          NOP DELAY      ; BETWEEN NIBLS.

.read5

 LDA Q6L,X              \ READ2    LDA Q6L,X
 BPL read5              \          BPL READ2      ; *** NO PAGE CROSS! ***
 CMP #&AA               \          CMP #$AA       ; DATA MARK 2?
 BNE read4              \          BNE RSYNC1     ; (IF NOT, IS IT DM1?)
 LDY #&56               \          LDY #$56       ; INIT NBUF2 INDEX.
                        \ *       (ADDED NIBL DELAY)

.read6

 LDA Q6L,X              \ READ3    LDA Q6L,X
 BPL read6              \          BPL READ3      ; *** NO PAGE CROSS! ***
 CMP #&AD               \          CMP #$AD       ; DATA MARK 3?
 BNE read4              \          BNE RSYNC1     ; (IF NOT, IS IT DM1?)
                        \ *       (CARRY SET IF DM3!)
 LDA #0                 \          LDA #$00       ; INIT CHECKSUM.

.read7

 DEY                    \ RDATA1   DEY
 STY ztemp0             \          STY IDX

.read8

 LDY Q6L,X              \ READ4    LDY Q6L,X
 BPL read8              \          BPL READ4      ; *** NO PAGE CROSS! ***
 EOR rtable-&96,Y       \          EOR DNIBL,Y    ; XOR 6-BIT NIBL.
 LDY ztemp0             \          LDY IDX
 STA buffr2+256,Y       \          STA NBUF2,Y    ; STORE IN NBUF2 PAGE.
 BNE read7              \          BNE RDATA1     ; TAKEN IF Y-REG NONZERO.

.read9

 STY ztemp0             \ RDATA2   STY IDX

.readA

 LDY Q6L,X              \ READ5    LDY Q6L,X
 BPL readA              \          BPL READ5      ; *** NO PAGE CROSS! ***
 EOR rtable-&96,Y       \          EOR DNIBL,Y    ; XOR 6-BIT NIBL.
 LDY ztemp0             \          LDY IDX
 STA buffr2,Y           \          STA NBUF1,Y    ; STORE IN NBUF1 PAGE.
 INY                    \          INY
 BNE read9              \          BNE RDATA2

.readB

 LDY Q6L,X              \ READ6    LDY Q6L,X      ; READ 7-BIT CSUM NIBL.
 BPL readB              \          BPL READ6      ; *** NO PAGE CROSS! ***
 CMP rtable-&96,Y       \          CMP DNIBL,Y    ; IF LAST NBUF1 NIBL NOT
 BNE readE              \          BNE RDERR      ; EQUAL CHKSUM NIBL THEN ERR.

.readC

 LDA Q6L,X              \ READ7    LDA Q6L,X
 BPL readC              \          BPL READ7      ; *** NO PAGE CROSS! ***
 CMP #&DE               \          CMP #$DE       ; FIRST BIT SLIP MARK?
 BNE readE              \          BNE RDERR      ; (ERR IF NOT)
 NOP                    \          NOP DELAY      ; BETWEEN NIBLS.

.readD

 LDA Q6L,X              \ READ8    LDA Q6L,X
 BPL readD              \          BPL READ8      ; *** NO PAGE CROSS! ***
 CMP #&AA               \          CMP #$AA       ; SECOND BIT SLIP MARK?
 BEQ readF              \          BEQ RDEXIT     ; (DONE IF IT IS)

.readE

 SEC                    \ RDERR    SEC INDICATE   ; 'ERROR EXIT'.
 RTS                    \          RTS RETURN     ; FROM READ16 OR RDADR16.

.readF

 CLC                    \ RDEXIT   CLC CLEAR      ; CARRY ON
 RTS                    \          RTS NORMAL     ; READ EXITS.

