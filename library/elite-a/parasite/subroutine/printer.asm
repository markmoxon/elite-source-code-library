\ ******************************************************************************
\
\       Name: printer
\       Type: Subroutine
\   Category: Text
\    Summary: This routine is commented out in the original source
\
\ ******************************************************************************

\.printer               \ These instructions are commented out in the original
\                       \ source
\TXA
\PHA
\
\LDA #&9C
\JSR tube_write
\
\JSR tube_read
\
\PLA
\TAX
\
\RTS

