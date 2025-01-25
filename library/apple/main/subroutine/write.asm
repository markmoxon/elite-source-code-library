\ ******************************************************************************
\
\       Name: write
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a sector's worth of data from the buffr2 buffer to the
\             current track and sector
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the WRITE16 routine in Apple DOS 3.3.
\ There is one instruction missing here that is in the original DOS.
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

.write

 SEC                    \ WRITE16  SEC ANTICIPATE ; WPROT ERR.
 STX ztemp1             \          STX SLOTZ      ; FOR ZERO PAGE ACCESS.

                        \ The following instruction from DOS 3.3 is omitted:
                        \
                        \          STX SLOTABS    ; FOR NON-ZERO PAGE.
                        \
                        \ This would populate SLOTABS (slot16 in Elite) with X,
                        \ which contains the slot number * 16
                        \
                        \ The value of slot16 is set to &60 in the wsect routine
                        \ and is never changed again, so this omission is
                        \ presumably to prevent the slot number from changing

 LDA Q6H,X              \          LDA Q6H,X
 LDA Q7L,X              \          LDA Q7L,X      ; SENSE WPROT FLAG.
 BMI write6             \          BMI WEXIT      ; IF HIGH, THEN ERR.
 LDA buffr2+256         \          LDA NBUF2
 STA ztemp0             \          STA WTEMP      ; FOR ZERO-PAGE ACCESS.
 LDA #&FF               \          LDA #$FF       ; SYNC DATA.
 STA Q7H,X              \          STA Q7H,X      ; (5)  WRITE 1ST NIBL.
 ORA Q6L,X              \          ORA Q6L,X      ; (4)
 PHA                    \          PHA (3)
 PLA                    \          PLA (4)        ; CRITICAL TIMING!
 NOP                    \          NOP (2)
 LDY #4                 \          LDY #4         ; (2)  FOR 5 NIBLS.

.write2

 PHA                    \ WSYNC    PHA (3)        ; EXACT TIMING.
 PLA                    \          PLA (4)        ; EXACT TIMING.
 JSR wbyte2             \          JSR WNIBL7     ; (13,9,6)  WRITE SYNC.
 DEY                    \          DEY (2)
 BNE write2             \          BNE WSYNC      ; (2*)  MUST NOT CROSS PAGE!
 LDA #&D5               \          LDA #$D5       ; (2)  1ST DATA MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)
 LDA #&AA               \          LDA #$AA       ; (2)  2ND DATA MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)
 LDA #&AD               \          LDA #$AD       ; (2)  3RD DATA MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)
 TYA                    \          TYA (2)        ; CLEAR CHKSUM.
 LDY #&56               \          LDY #$56       ; (2)  NBUF2 INDEX.
 BNE write4             \          BNE WDATA1     ; (3)  ALWAYS.  NO PAGE
                        \                                CROSS!!

.write3

 LDA buffr2+256,Y       \ WDATA0   LDA NBUF2,Y    ; (4)  PRIOR 6-BIT NIBL.

.write4

 EOR buffr2+255,Y       \ WDATA1   EOR NBUF2-1,Y  ; (5)  XOR WITH CURRENT.
                        \ *   (NBUF2 MUST BE ON PAGE BOUNDARY FOR TIMING!!)
 TAX                    \          TAX (2)        ; INDEX TO 7-BIT NIBL.
 LDA wtable,X           \          LDA NIBL,X     ; (4)  MUST NOT CROSS PAGE!
 LDX ztemp1             \          LDX SLOTZ      ; (3)  CRITICAL TIMING!
 STA Q6H,X              \          STA Q6H,X      ; (5)  WRITE NIBL.
 LDA Q6L,X              \          LDA Q6L,X      ; (4)
 DEY                    \          DEY (2)        ; NEXT NIBL.
 BNE write3             \          BNE WDATA0     ; (2*)  MUST NOT CROSS PAGE!
 LDA ztemp0             \          LDA WTEMP      ; (3)  PRIOR NIBL FROM BUF6.
 NOP                    \          NOP (2)        ; CRITICAL TIMING.

.write5

 EOR buffr2,Y           \ WDATA2   EOR NBUF1,Y    ; (4)  XOR NBUF1 NIBL.
 TAX                    \          TAX (2)        ; INDEX TO 7-BIT NIBL.
 LDA wtable,X           \          LDA NIBL,X     ; (4)
 LDX slot16             \          LDX SLOTABS    ; (4)  TIMING CRITICAL.
 STA Q6H,X              \          STA Q6H,X      ; (5)  WRITE NIBL.
 LDA Q6L,X              \          LDA Q6L,X      ; (4)
 LDA buffr2,Y           \          LDA NBUF1,Y    ; (4)  PRIOR 6-BIT NIBL.
 INY                    \          INY (2)        ; NEXT NBUF1 NIBL.
 BNE write5             \          BNE WDATA2     ; (2*)  MUST NOT CROSS PAGE!
 TAX                    \          TAX (2)        ; LAST NIBL AS CHKSUM.
 LDA wtable,X           \          LDA NIBL,X     ; (4)  INDEX TO 7-BIT NIBL.
 LDX ztemp1             \          LDX SLOTZ      ; (3)
 JSR wbyte3             \          JSR WNIBL      ; (6,9,6)  WRITE CHKSUM.
 LDA #&DE               \          LDA #$DE       ; (2)  DM4, BIT SLIP MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)    WRITE IT.
 LDA #&AA               \          LDA #$AA       ; (2)  DM5, BIT SLIP MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)    WRITE IT.
 LDA #&EB               \          LDA #$EB       ; (2)  DM6, BIT SLIP MARK.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,6)    WRITE IT.
 LDA #&FF               \          LDA #$FF       ; (2) TURN-OFF BYTE.
 JSR wbyte              \          JSR WNIBL9     ; (15,9,9)  WRITE IT.
 LDA Q7L,X              \          LDA Q7L,X      ; OUT OF WRITE MODE.

.write6

 LDA Q6L,X              \ WEXIT    LDA Q6L,X      ; TO READ MODE.
 RTS                    \          RTS RETURN     ; FROM WRITE.

