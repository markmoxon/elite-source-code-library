\ ******************************************************************************
\
\       Name: info_menu
\       Type: Subroutine
\   Category: Elite-A
\    Summary: AJD
\
\ ******************************************************************************

.info_menu

 LDX #&00
 JSR menu
 CMP #&01
 BNE n_shipsag
 JMP ships_ag

.n_shipsag

 CMP #&02
 BNE n_shipskw
 JMP ships_kw

.n_shipskw

 CMP #&03
 BNE n_equipdat
 JMP equip_data

.n_equipdat

 CMP #&04
 BNE n_controls
 JMP controls

.n_controls

 CMP #&05
 BNE jmp_start3
 JMP trading

.jmp_start3

 JSR dn2
 JMP BAY

