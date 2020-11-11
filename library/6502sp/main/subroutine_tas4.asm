\ ******************************************************************************
\       Name: TAS4
\ ******************************************************************************

.TAS4

 LDX K%+NI%,Y
 STX Q
 LDA XX15
 JSR MULT12
 LDX K%+NI%+2,Y
 STX Q
 LDA XX15+1
 JSR MAD
 STA S
 STX R
 LDX K%+NI%+4,Y
 STX Q
 LDA XX15+2
 JMP MAD

