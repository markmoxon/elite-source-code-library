\ ******************************************************************************
\
\       Name: rdaddr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a track address field
\
\ ------------------------------------------------------------------------------
\
\ This routine is identical to the RDADR16 routine in Apple DOS 3.3.
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

.rdaddr

 LDY #&FC               \ RDADR16  LDY #$FC
 STY ztemp0             \          STY COUNT      ; 'MUST FIND' COUNT.

.rdadr2

 INY                    \ RDASYN   INY
 BNE rdadr3             \          BNE RDA1       ; LOW ORDER OF COUNT.
 INC ztemp0             \          INC COUNT      ; (2K NIBLS TO FIND
 BEQ rdadrD             \          BEQ RDERR      ; ADR MARK, ELSE ERR)

.rdadr3

 LDA Q6L,X              \ RDA1     LDA Q6L,X      ; READ NIBL.
 BPL rdadr3             \          BPL RDA1       ; *** NO PAGE CROSS! ***

.rdadr4

 CMP #&D5               \ RDASN1   CMP #$D5       ; ADR MARK 1?
 BNE rdadr2             \          BNE RDASYN     ; (LOOP IF NOT)
 NOP                    \          NOP ADDED      ; NIBL DELAY.

.rdadr5

 LDA Q6L,X              \ RDA2     LDA Q6L,X
 BPL rdadr5             \          BPL RDA2       ; *** NO PAGE CROSS! ***
 CMP #&AA               \          CMP #$AA       ; ADR MARK 2?
 BNE rdadr4             \          BNE RDASN1     ; (IF NOT, IS IT AM1?)
 LDY #3                 \          LDY #$3        ; INDEX FOR 4-BYTE READ.
                        \ *       (ADDED NIBL DELAY)

.rdadr6

 LDA Q6L,X              \ RDA3     LDA Q6L,X
 BPL rdadr6             \          BPL RDA3       ; *** NO PAGE CROSS! ***
 CMP #&96               \          CMP #$96       ; ADR MARK 3?
 BNE rdadr4             \          BNE RDASN1     ; (IF NOT, IS IT AM1?)
                        \ *       (LEAVES CARRY SET!)
 LDA #0                 \          LDA #$0        ; INIT CHECKSUM.

.rdadr7

 STA ztemp1             \ RDAFLD   STA CSUM

.rdadr8

 LDA Q6L,X              \ RDA4     LDA Q6L,X      ; READ 'ODD BIT' NIBL.
 BPL rdadr8             \          BPL RDA4       ; *** NO PAGE CROSS! ***
 ROL A                  \          ROL A          ; ALIGN ODD BITS, '1' INTO
                        \                           LSB.
 STA ztemp0             \          STA LAST       ; (SAVE THEM)

.rdadr9

 LDA Q6L,X              \ RDA5     LDA Q6L,X      ; READ 'EVEN BIT' NIBL.
 BPL rdadr9             \          BPL RDA5       ; *** NO PAGE CROSS! ***
 AND ztemp0             \          AND LAST       ; MERGE ODD AND EVEN BITS.
 STA idfld,Y            \          STA CSSTV,Y    ; STORE DATA BYTE.
 EOR ztemp1             \          EOR CSUM       ; XOR CHECKSUM.
 DEY                    \          DEY
 BPL rdadr7             \          BPL RDAFLD     ; LOOP ON 4 DATA BYTES.
 TAY                    \          TAY IF         ; FINAL CHECKSUM
 BNE rdadrD             \          BNE RDERR      ; NONZERO, THEN ERROR.

.rdadrA

 LDA Q6L,X              \ RDA6     LDA Q6L,X      ; FIRST BIT-SLIP NIBL.
 BPL rdadrA             \          BPL RDA6       ; *** NO PAGE CROSS! ***
 CMP #&DE               \          CMP #$DE
 BNE rdadrD             \          BNE RDERR      ; ERROR IF NONMATCH.
 NOP                    \          NOP DELAY      ; BETWEEN NIBLS.

.rdadrB

 LDA Q6L,X              \ RDA7     LDA Q6L,X      ; SECOND BIT-SLIP NIBL.
 BPL rdadrB             \          BPL RDA7       ; *** NO PAGE CROSS! ***
 CMP #&AA               \          CMP #$AA
 BNE rdadrD             \          BNE RDERR      ; ERROR IF NONMATCH.

.rdadrC

 CLC                    \ RDEXIT   CLC CLEAR      ; CARRY ON
 RTS                    \          RTS NORMAL     ; READ EXITS.

.rdadrD

 SEC                    \ RDERR    SEC INDICATE   ; 'ERROR EXIT'.
 RTS                    \          RTS RETURN     ; FROM READ16 OR RDADR16.

