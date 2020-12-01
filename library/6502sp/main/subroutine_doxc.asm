\ ******************************************************************************
\
\       Name: DOXC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specified column
\
\ ******************************************************************************

.DOXC

 PHA

 BIT printflag          \ If bit 7 of printflag is clear (printer output is not
 BPL DOX1               \ enabled), jump to DOX1 to skip the printer-specific
                        \ code below

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

