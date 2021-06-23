\ ******************************************************************************
\
IF _ELITE_A_FLIGHT
\       Name: tnpr
ELIF _ELITE_A_6502SP_PARA
\       Name: tnpr_FLIGHT
ENDIF
\       Type: Subroutine
\   Category: Market
\    Summary: AJD
\
\ ******************************************************************************

IF _ELITE_A_FLIGHT

.tnpr

ELIF _ELITE_A_6502SP_PARA

.tnpr_FLIGHT

ENDIF

 CPX #&10
 BEQ n_aliens
 CPX #&0D
 BCS l_2b04

.n_aliens

 LDY #&0C               \ Related to tnpr, but not the same
 SEC
 LDA QQ20+16

.l_2af9

 ADC QQ20,Y
 BCS n_cargo
 DEY
 BPL l_2af9
 CMP new_hold

.n_cargo

 RTS

.l_2b04

 LDA QQ20,X
 ADC #&00
 RTS

