\ ******************************************************************************
\
IF _ELITE_A_ENCYCLOPEDIA
\       Name: info_menu
ELIF _ELITE_A_6502SP_PARA
\       Name: encyclopedia
ENDIF
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Show the Encyclopedia screen
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   jmp_start3          Make a short, high beep, delay for one second, and go to
\                       the docking bay (i.e. show the Status Mode screen)
\
\ ******************************************************************************

IF _ELITE_A_ENCYCLOPEDIA

.info_menu

ELIF _ELITE_A_6502SP_PARA

.encyclopedia

ENDIF

 LDX #0                 \ AJD
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

IF _ELITE_A_ENCYCLOPEDIA

 CMP #&05
 BNE jmp_start3
 JMP trading

.jmp_start3

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen)


ELIF _ELITE_A_6502SP_PARA

 CMP #&05
 BNE jmp_start3_dup
 JMP trading

.jmp_start3_dup

 JMP dn2

ENDIF

