\ ******************************************************************************
\       Name: USOSWRCH
\ ******************************************************************************

.USOSWRCH

 STX SC
 TAX
 BPL OHMYGOD
 ASL A
 TAX
 CPX #39
 BCS OHMYGOD
 LDA JMPTAB,X
 SEI
 STA WRCHV
 LDA JMPTAB+1,X
 STA WRCHV+1
 CLI
 RTS

.OHMYGOD

 LDX SC
 JMP TT26

