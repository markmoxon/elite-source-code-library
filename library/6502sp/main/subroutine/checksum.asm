\ ******************************************************************************
\
\       Name: Checksum
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.Checksum

 SEC
 LDY #0
 STY V
 LDX #&10
 LDA (SC)
 TXA

.CHKLoop

 STX V+1
 STY T
 ADC (V),Y
 EOR T
 SBC V+1

 DEY

 BNE CHKLoop

 INX

 CPX #&A0
 BCC CHKLoop

 CMP S%-1

IF _REMOVE_CHECKSUMS
 NOP
 NOP
ELSE
 BNE Checksum
ENDIF

 RTS

