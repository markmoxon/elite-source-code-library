\ ******************************************************************************
\       Name: CHPR
\ ******************************************************************************

.CHPR

\PRINT

.CHPRD

 STA K3
 CMP #32
 BCC P%+4
 INC XC
 LDA QQ17
INA \++
 BEQ rT9
 BIT printflag
 BPL noprinter
 LDA #printcode
 JSR OSWRCH

.noprinter

 LDA K3
 JSR OSWRCH
 CLC
 RTS

