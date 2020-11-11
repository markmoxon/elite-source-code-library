\ ******************************************************************************
\       Name: DOXC
\ ******************************************************************************

.DOXC

 PHA
 BIT printflag
 BPL DOX1
 CMP XC
 BCC DOXLF
 BEQ DOX1
 PHY
 PHX \++
 SBC XC
 TAX

.DOXL1

 LDA #32
 JSR TT26
 DEX
 BNE DOXL1
 PLX
 PLY \++

.DOX1

 LDA #SETXC
 JSR OSWRCH
 PLA
 STA XC
 JMP OSWRCH

.DOXLF

 LDA #13
 JSR TT26
 JMP DOX1

