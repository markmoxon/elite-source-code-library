\ ******************************************************************************
\
\       Name: trading
\       Type: Subroutine
\   Category: Elite-A: Encyclopedia
\    Summary: AJD
\
\ ******************************************************************************

.trading

.l_restart

IF _ELITE_A_ENCYCLOPEDIA

 JSR PAUSE2

ELIF _ELITE_A_6502SP_PARA

 JSR check_keys
 TXA
 BEQ l_restart

ENDIF

 JMP BAY

