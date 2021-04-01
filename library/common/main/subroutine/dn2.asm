\ ******************************************************************************
\
\       Name: dn2
\       Type: Subroutine
\   Category: Text
IF _CASSETTE_VERSION OR _DISC_DOCKED OR _6502SP_VERSION \ Comment
\    Summary: Make a short, high beep and delay for 1 second
ELIF _MASTER_VERSION
\    Summary: Make a short, high beep and delay for 0.5 seconds
ENDIF
\
\ ******************************************************************************

.dn2

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _6502SP_VERSION \ Platform

 LDY #50                \ Delay for 50 vertical syncs (50/50 = 1 second) and
 JMP DELAY              \ return from the subroutine using a tail call

ELIF _MASTER_VERSION

 LDY #25                \ Delay for 25 vertical syncs (25/50 = 0.5 second) and
 JMP DELAY              \ return from the subroutine using a tail call

ENDIF

