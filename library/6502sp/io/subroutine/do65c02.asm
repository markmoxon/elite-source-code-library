\ ******************************************************************************
\
\       Name: do65C02
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.do65C02

.whiz

 LDA (0)
 PHA
 LDA (2)
 STA (0)
 PLA
 STA (2)
\NOP
\NOP
\NOP
\NOP
 INC 0
 BNE P%+4
 INC 1
 LDA 2
 BNE P%+4
 DEC 3
 DEC 2                  \ SC = 2
 DEA
 CMP 0
 LDA 3
 SBC 1
 BCS whiz
 JMP (0,X)
.end65C02

protlen = end65C02 - do65C02

