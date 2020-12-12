\ ******************************************************************************
\       Name: CATS
\ by sending a #DOCATF command to the I/O processor
\ ******************************************************************************

.CATS

 JSR GTDRV
 BCS DELT-1
 STA CTLI+1
 STA DTW7
 LDA #4
 JSR DETOK
 LDA #DOCATF
 JSR OSWRCH
 LDA #1
 JSR OSWRCH
 STA XC
 LDX #(CTLI MOD256)
 LDY #(CTLI DIV256)
 JSR SCLI2
 LDA #DOCATF
 JSR OSWRCH
 LDA #0
 JSR OSWRCH
 CLC
 RTS

