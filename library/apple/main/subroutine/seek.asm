\ ******************************************************************************
\
\       Name: seek
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fast seek routine
\
\ ------------------------------------------------------------------------------
\
\ This routine is almost identical to the SEEK routine in Apple DOS 3.3. There
\ is one extra instruction and one moved instruction when compared to the
\ original DOS.
\
\ These extra instructions double the track number in A.
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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The track number
\
\ ******************************************************************************

.seek

 STX ztemp0             \ SEEK     STX SLOTTEMP   ; SAVE X-REG
                        \          STA TRKN       ; SAVE TARGET TRACK

 ASL A                  \ This is an extra instruction that doubles the track
                        \ number in A

 CMP curtrk             \          CMP CURTRK     ; ON DESIRED TRACK?
 BEQ step3              \          BEQ SEEKRTS    ; YES, RETURN

 STA ztemp1             \ This is the second instruction from above, which has
                        \ been moved here (STA TRKN)
                        \
                        \ This saves the now-doubled track number in ztemp1

 LDA #0                 \          LDA #$0
 STA ztemp2             \          STA TRKCNT     ; HALFTRACK COUNT.

.seek2

 LDA curtrk             \ SEEK2    LDA CURTRK     ; SAVE CURTRK FOR
 STA ztemp3             \          STA PRIOR      ; DELAYED TURNOFF.
 SEC                    \          SEC
 SBC ztemp1             \          SBC TRKN       ; DELTA-TRACKS.
 BEQ seek7              \          BEQ SEEKEND    ; BR IF CURTRK=DESTINATION
 BCS seek3              \          BCS OUT        ; (MOVE OUT, NOT IN)
 EOR #&FF               \          EOR #$FF       ; CALC TRKS TO GO.
 INC curtrk             \          INC CURTRK     ; INCR CURRENT TRACK (IN).
 BCC seek4              \          BCC MINTST     ; (ALWAYS TAKEN)

.seek3

 ADC #&FE               \ OUT      ADC #$FE       ; CALC TRKS TO GO.
 DEC curtrk             \          DEC CURTRK     ; DECR CURRENT TRACK (OUT).

.seek4

 CMP ztemp2             \ MINTST   CMP TRKCNT
 BCC seek5              \          BCC MAXTST     ; AND 'TRKS MOVED'.
 LDA ztemp2             \          LDA TRKCNT

.seek5

 CMP #12                \ MAXTST   CMP #$C
 BCS seek6              \          BCS STEP2      ; IF TRKCNT>$B LEAVE Y ALONE
                        \                           (Y=$B).
 TAY                    \ STEP     TAY            ; ELSE SET ACCELERATION INDEX
                        \                           IN Y

.seek6                  \ STEP2    EQU *

 SEC                    \          SEC            ; CARRY SET=PHASE ON
 JSR step               \          JSR SETPHASE   ; PHASE ON
 LDA armtab,Y           \          LDA ONTABLE,Y  ; FOR 'ONTIME'.
 JSR armwat             \          JSR MSWAIT     ; (100 USEC INTERVALS)
                        \ *
 LDA ztemp3             \          LDA PRIOR
 CLC                    \          CLC            ; CARRY CLEAR=PHASE OFF
 JSR step2              \          JSR CLRPHASE   ; PHASE OFF
 LDA armtb2,Y           \          LDA OFFTABLE,Y ; THEN WAIT 'OFFTIME'.
 JSR armwat             \          JSR MSWAIT     ; (100 USEC INTERVALS)
 INC ztemp2             \          INC TRKCNT     ; 'TRACKS MOVED' COUNT.
 BNE seek2              \          BNE SEEK2      ; (ALWAYS TAKEN)
                        \ *
.seek7                  \ SEEKEND  EQU *          ; END OF SEEKING

 JSR armwat             \          JSR MSWAIT     ; A=0: WAIT 25 MS SETTLE
 CLC                    \          CLC            ; AND TURN OFF PHASE
                        \ *
                        \ * TURN HEAD STEPPER PHASE ON/OFF
                        \ *

.step                   \ SETPHASE EQU *

 LDA curtrk             \          LDA CURTRK     ; GET CURRENT PHASE

.step2                  \ CLRPHASE EQU *

 AND #3                 \          AND #3         ; MASK FOR 1 OF 4 PHASES
 ROL A                  \          ROL A          ; DOUBLE FOR PHASE INDEX
 ORA ztemp0             \          ORA SLOTTEMP
 TAX                    \          TAX
 LDA phsoff,X           \          LDA PHASEOFF,X ; FLIP THE PHASE
 LDX ztemp0             \          LDX SLOTTEMP   ; RESTORE X-REG

.step3

 RTS                    \ SEEKRTS  RTS            ; AND RETURN

