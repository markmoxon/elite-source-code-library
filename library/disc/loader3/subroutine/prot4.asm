\ ******************************************************************************
\
\       Name: PROT4
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

IF _SRAM_DISC

.PROT4

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #255
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 JMP PROT1              \ ???

ENDIF

