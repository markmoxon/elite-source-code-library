\ ******************************************************************************
\
\       Name: ships_ag
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: AJD
\
\ ******************************************************************************

.ships_ag

.ships_kw

 PHA
 TAX
 JSR menu
 SBC #&00
 PLP
 BCS ship_over
 ADC menu_entry+1

.ship_over

 STA TYPE
 CLC
 ADC #&07
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDX TYPE

IF _ELITE_A_ENCYCLOPEDIA

 LDA ship_file,X
 CMP ship_load+4
 BEQ ship_skip
 STA ship_load+4
 LDX #LO(ship_load)
 LDY #HI(ship_load)
 JSR OSCLI

.ship_skip

ELIF _ELITE_A_6502SP_PARA

 LDA ship_posn,X
 TAX
 LDY #0
 JSR install_ship

ENDIF

 LDX TYPE
 LDA ship_centre,X
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR ZINF
 LDA #&60
 STA INWK+14
 LDA #&B0
 STA INWK+7
 LDX #&7F
 STX INWK+29
 STX INWK+30
 INX
 STA QQ17
 LDA TYPE
 JSR write_card

IF _ELITE_A_ENCYCLOPEDIA

 LDX TYPE
 LDA ship_posn,X
 JSR NWSHP

.l_release

 JSR RDKEY
 BNE l_release

ELIF _ELITE_A_6502SP_PARA

 LDA #0
 JSR NWSHP
 JSR l_release

ENDIF

.l_395a

 LDX TYPE
 LDA ship_dist,X
 CMP INWK+7
 BEQ l_3962
 DEC INWK+7

.l_3962

 JSR MVEIT
 LDA #&80
 STA INWK+6
 ASL A
 STA INWK
 STA INWK+3
 JSR LL9
 DEC MCNT

IF _ELITE_A_ENCYCLOPEDIA

 JSR WSCAN
 JSR RDKEY

ELIF _ELITE_A_6502SP_PARA

 JSR check_keys
 CPX #0

ENDIF

 BEQ l_395a
 JMP BAY

