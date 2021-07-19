\ ******************************************************************************
\
\       Name: trading
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Wait until a key is pressed and show the Encyclopedia screen
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   l_restart           Does exactly the same as a call to trading
\
\ ******************************************************************************

.trading

.l_restart

IF _ELITE_A_ENCYCLOPEDIA

 JSR PAUSE2             \ Call PAUSE2 to wait until a key is pressed, ignoring
                        \ any existing key press

ELIF _ELITE_A_6502SP_PARA

 JSR check_keys         \ AJD
 TXA
 BEQ l_restart

ENDIF

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Encyclopedia screen)

