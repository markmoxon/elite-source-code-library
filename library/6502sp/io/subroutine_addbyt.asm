\ ******************************************************************************
\       Name: ADDBYT
\ ******************************************************************************

.ADDBYT

 INC LINTAB
 LDX LINTAB
 STA TABLE-1,X
 INX
 CPX LINMAX
 BCC RTS1
 LDY #0
 DEC LINMAX
 LDA TABLE+3
 CMP #&FF
 BEQ doalaser

.LL27

 LDA TABLE,Y
 STA X1
 LDA TABLE+1,Y
 STA Y1
 LDA TABLE+2,Y
 STA X2
 LDA TABLE+3,Y
 STA Y2
 STY T1
 JSR LOIN
 LDA T1
 CLC
 ADC #4

.Ivedonealaser

 TAY
 CMP LINMAX
 BCC LL27

.DRLR1

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

.doalaser

 LDA COL
 PHA
 LDA #RED
 STA COL
 LDA TABLE+4
 STA X1
 LDA TABLE+5
 STA Y1
 LDA TABLE+6
 STA X2
 LDA TABLE+7
 STA Y2
 JSR LOIN
 PLA
 STA COL
 LDA #8
 BNE Ivedonealaser

