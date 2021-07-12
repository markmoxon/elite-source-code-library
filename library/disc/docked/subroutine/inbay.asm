\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
IF _DISC_DOCKED
\    Summary: This routine is unused and is never run
ELIF _ELITE_A_DOCKED
\    Summary: Set the break handler and go to the docking bay without showing
\             the tunnel or ship hanger, or checking mission progress
ENDIF
\
\ ******************************************************************************

.INBAY

IF _ELITE_A_DOCKED

 JSR BRKBK              \ Call BRKBK to set BRKV to point to the BRBR routine

 JMP icode_set          \ Jump to icode_set to reset a number of flight
                        \ variables and workspaces and go to the docking bay
                        \ (i.e. show the Status Mode screen)

ENDIF

IF _DISC_DOCKED

 LDX #0                 \ This code is never run, and seems to have no effect
 LDY #0
 JSR &8888
 JMP SCRAM

ELIF _ELITE_A_DOCKED

 BRK                    \ This code is never run, and seems to have no effect
 LDA #0
 JSR SCRAM
 JSR RES2
 JMP TT170

ENDIF

