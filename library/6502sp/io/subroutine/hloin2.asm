\ ******************************************************************************
\
\       Name: HLOIN2
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: 
\
\ ******************************************************************************

.HLOIN2

 LDX X1
 STY Y2
 INY
 STY Q
 LDA COL
 JMP HLOIN3 \any colour

