\ ******************************************************************************
\       Name: BEGINLIN   see LL155 in tape
\ ******************************************************************************

\.............Empty Linestore after copying over Tube .........

.BEGINLIN

\was LL155 -CLEAR LINEstr
 STA LINMAX
 LDA #0
 STA LINTAB
 LDA #&82
 JMP USOSWRCH

.^RTS1

 RTS

