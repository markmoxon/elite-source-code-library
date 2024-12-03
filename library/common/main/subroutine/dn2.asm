\ ******************************************************************************
\
\       Name: dn2
\       Type: Subroutine
\   Category: Text
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Comment
\    Summary: Make a short, high beep and delay for 1 second
ELIF _MASTER_VERSION
\    Summary: Make a short, high beep and delay for 0.5 seconds
ELIF _APPLE_VERSION
\    Summary: Make a low, long beep and delay for 0.5 seconds
ENDIF
\
\ ******************************************************************************

.dn2

IF NOT(_APPLE_VERSION)

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

ELIF _APPLE_VERSION

 JSR BOOP               \ Call the BOOP routine to make a low, long beep

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDY #50                \ Wait for 50/50 of a second (1 second) and return
 JMP DELAY              \ from the subroutine using a tail call

ELIF _ELECTRON_VERSION

 LDY #200               \ Wait for 200 delay loops and return from the
 JMP DELAY              \ subroutine using a tail call

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDY #25                \ Wait for 25/50 of a second (0.5 second) and return
 JMP DELAY              \ from the subroutine using a tail call

ELIF _C64_VERSION

 LDY #50                \ Wait for 50/50 of a second (1 second) on PAL systems,
 JMP DELAY              \ or 50/60 of a second (0.83 seconds) on NTSC, and
                        \ return from the subroutine using a tail call

ENDIF

