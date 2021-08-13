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
\  Deep dive: The Encyclopedia Galactica
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   jmp_start3          Make a short, high beep, delay for one second, and go to
\                       the docking bay (i.e. show the Encyclopedia screen)
\
\ ******************************************************************************

IF _ELITE_A_ENCYCLOPEDIA

.info_menu

ELIF _ELITE_A_6502SP_PARA

.encyclopedia

ENDIF

 LDX #0                 \ Call menu with X = 0 to show menu 0, the main menu for
 JSR menu               \ the Encyclopedia Galactica, and return the choice in A

 CMP #1                 \ If A <> 1, skip the following instruction to check the
 BNE n_shipsag          \ other options

 JMP ships_ag           \ Option 1 was chosen, so jump to ships_ag with A = 1 to
                        \ show the Ships A-G menu

.n_shipsag

 CMP #2                 \ If A <> 2, skip the following instruction to check the
 BNE n_shipskw          \ other options

 JMP ships_kw           \ Option 2 was chosen, so jump to ships_kw with A = 2 to
                        \ show the Ships K-W menu

.n_shipskw

 CMP #3                 \ If A <> 3, skip the following instruction to check the
 BNE n_equipdat         \ other options

 JMP equip_data         \ Option 3 was chosen, so jump to equip_data to show the
                        \ Equipment menu

.n_equipdat

 CMP #4                 \ If A <> 4, skip the following instruction to check the
 BNE n_controls         \ other options

 JMP controls           \ Option 4 was chosen, so jump to controls to show the
                        \ Controls menu

.n_controls

IF _ELITE_A_ENCYCLOPEDIA

 CMP #5                 \ If A <> 5, skip the following instruction and jump to
 BNE jmp_start3         \ jmp_start3 to make a beep and show the main menu

 JMP trading            \ Option 5 was chosen, so jump to trading to pause and
                        \ show the main menu (there is no option 5 in the main
                        \ menu, so this code is never reached and is presumably
                        \ a remnant of a fifth menu about trading that was
                        \ removed)

.jmp_start3

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Encyclopedia screen)


ELIF _ELITE_A_6502SP_PARA

 CMP #5                 \ If A <> 5, skip the following instruction
 BNE P%+5

 JMP trading            \ Option 5 was chosen, so jump to trading to pause and
                        \ show the main menu (there is no option 5 in the main
                        \ menu, so this code is never reached and is presumably
                        \ a remnant of a fifth menu about trading that was
                        \ removed)

 JMP dn2                \ Jump to dn2 to make a short, high beep and delay for 1
                        \ second, returning from the subroutine using a tail
                        \ call

ENDIF

