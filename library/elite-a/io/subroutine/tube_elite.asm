\ ******************************************************************************
\
\       Name: tube_elite
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_elite

 LDX #&FF
 TXS
 LDA #LO(tube_wrch)
 STA WRCHV
 LDA #HI(tube_wrch)
 STA WRCHV+&01
 LDA #LO(tube_brk)
 STA BRKV
 LDA #HI(tube_brk)
 STA BRKV+&01
 LDX #LO(tube_run)
 LDY #HI(tube_run)
 JMP OSCLI

