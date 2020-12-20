\ ******************************************************************************
\
\       Name: DEEOR
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.DEEOR

 LDY #0
 STY SC
 LDX #&13

.DEEL

 STX SC+1
 TYA
 EOR (SC),Y
 EOR #&75

IF _REMOVE_CHECKSUMS

 NOP
 NOP

ELSE

 STA (SC),Y

ENDIF

 DEY
 BNE DEEL
 INX
 CPX #&A0
 BNE DEEL
 JMP BRKBK

