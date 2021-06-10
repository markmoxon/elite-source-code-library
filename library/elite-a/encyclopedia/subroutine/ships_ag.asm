\ ******************************************************************************
\
\       Name: ships_ag
\       Type: Subroutine
\   Category: Elite-A
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

 STA &8C
 CLC
 ADC #&07
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDX &8C

IF _ELITE_A_ENCYCLOPEDIA

 LDA ship_file,X
 CMP ship_load+&04
 BEQ ship_skip
 STA ship_load+&04
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

 LDX &8C
 LDA ship_centre,X
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR ZINF
 LDA #&60
 STA &54
 LDA #&B0
 STA &4D
 LDX #&7F
 STX &63
 STX &64
 INX
 STA QQ17
 LDA &8C
 JSR write_card

IF _ELITE_A_ENCYCLOPEDIA

 LDX &8C
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

 LDX &8C
 LDA ship_dist,X
 CMP &4D
 BEQ l_3962
 DEC &4D

.l_3962

 JSR MVEIT
 LDA #&80
 STA &4C
 ASL A
 STA &46
 STA &49
 JSR LL9
 DEC &8A

IF _ELITE_A_ENCYCLOPEDIA

 JSR WSCAN
 JSR RDKEY

ELIF _ELITE_A_6502SP_PARA

 JSR check_keys
 CPX #0

ENDIF

 BEQ l_395a
 JMP BAY

