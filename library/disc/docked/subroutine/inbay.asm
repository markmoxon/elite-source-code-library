\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
IF _DISC_DOCKED
\    Summary: An unused routine that is never run
ELIF _ELITE_A_DOCKED
\    Summary: Set the break handler and go to the docking bay without showing
\             the tunnel or ship hangar, or checking mission progress
ENDIF
\
\ ******************************************************************************

.INBAY

IF _DISC_DOCKED

 LDX #0                 \ This code is never run, but it takes up the same
 LDY #0                 \ number of bytes as the INBAY routine in the flight
 JSR &8888              \ code, so if the flight code *LOADs the docked code in
 JMP SCRAM              \ its own version of the INBAY routine, then execution
                        \ will fall through into the DOBEGIN routine below once
                        \ the docked binary has loaded
                        \
                        \ This enables the docked code to choose whether to load
                        \ the docked code and jump to DOBEGIN to restart the
                        \ game (in which case the flight code simply *LOADs the
                        \ docked code), or whether to dock with the space
                        \ station and continue the game (in which case the
                        \ flight code *RUNs the docked code, which has an
                        \ execution address of S% at the start of the docked
                        \ code, which contains a JMP DOENTRY instruction)

ELIF _ELITE_A_DOCKED

 JSR BRKBK              \ Call BRKBK to set BRKV to point to the BRBR routine

 JMP icode_set          \ Jump to icode_set to reset a number of flight
                        \ variables and workspaces and go to the docking bay
                        \ (i.e. show the Status Mode screen)

 EQUB 0                 \ This pads the INBAY routine so it takes up the same
                        \ number of bytes as the INBAY routine in the flight
                        \ code, so if the flight code *LOADs the docked code in
                        \ its own version of the INBAY routine, then execution
                        \ will fall through into the code below once the docked
                        \ binary has loaded
                        \
                        \ This enables the docked code to choose whether to load
                        \ the docked code and jump to DOBEGIN to restart the
                        \ game (in which case the flight code simply *LOADs the
                        \ docked code), or whether to dock with the space
                        \ station and continue the game (in which case the
                        \ flight code *RUNs the docked code, which has an
                        \ execution address of S% at the start of the docked
                        \ code, which contains a JMP DOENTRY instruction)

                        \ If we get here then we have loaded the docked code and
                        \ fallen through to this point, so we need to restart
                        \ the game

 LDA #0                 \ Call SCRAM to set save_lock to 0 (i.e. this is a new
 JSR SCRAM              \ game) and set the break handler

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP TT170              \ Jump to TT170 to start the game

ENDIF

