\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
\    Summary: This routine is unused and is never run
\
\ ******************************************************************************

.INBAY

IF _DISC_DOCKED

 LDX #0                 \ This code is never run, and seems to have no effect
 LDY #0
 JSR &8888
 JMP SCRAM

ELIF _ELITE_A_DOCKED

 JSR BRKBK              \ AJD
 JMP icode_set

 EQUB 0
 \ dead entry

 LDA #0                 \ Call SCRAM to set save_lock to 0 and set the break
 JSR SCRAM              \ handler

 JSR RES2
 JMP TT170

ENDIF

