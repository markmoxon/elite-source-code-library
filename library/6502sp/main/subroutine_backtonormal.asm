\ ******************************************************************************
\       Name: backtonormal
\ ******************************************************************************

.backtonormal

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

 LDA #0
 BEQ DODOSVN

