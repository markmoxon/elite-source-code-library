\ ******************************************************************************
\
\       Name: CATLOD
\       Type: Subroutine
\   Category: Save and load
\    Summary: This routine is commented out in the original source
\
\ ******************************************************************************

\.CATLOD                \ These instructions are commented out in the original
\                       \ source
\DEC CTLDL+8
\JSR CATLODS
\INC CTLDL+8
\
\.CATLODS
\
\LDA #127
\LDX #LO(CTLDL)
\LDY #HI(CTLDL)
\JMP OSWORD
\
\.CTLDL
\
\EQUB 0
\EQUD &0E00
\EQUB 3
\EQUB &53
\EQUB 0
\EQUB 1
\EQUB &21
\EQUB 0

