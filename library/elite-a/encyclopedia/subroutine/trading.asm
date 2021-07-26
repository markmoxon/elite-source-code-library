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

 JSR check_keys         \ Call check_keys to wait until a key is pressed,
                        \ quitting the game if the game if COPY (pause) and
                        \ ESCAPE are pressed

 TXA                    \ Copy the number of the key pressed into A

 BEQ l_restart          \ If check_keys returned with X = 0, then we paused the
                        \ game with COPY and then unpaused it with DELETE, in
                        \ which case loop back to l_restart to keep checking for
                        \ key presses

ENDIF

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Encyclopedia screen)

