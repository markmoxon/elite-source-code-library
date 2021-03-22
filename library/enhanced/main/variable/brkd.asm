\ ******************************************************************************
\
\       Name: brkd
\       Type: Variable
\   Category: Utility routines
\    Summary: The brkd counter for error handling
\
\ ------------------------------------------------------------------------------
\
IF _DISC_VERSION OR _6502SP_VERSION
\ This counter starts at zero, and is decremented whenever the BRKV handler at
ELIF _MASTER_VERSION
\ This counter starts at -1, and is decremented whenever the BRKV handler at
ENDIF
\ BRBR prints an error message. It is incremented every time an error message
\ is printer out as part of the TITLE routine.
\
\ ******************************************************************************

.brkd

IF _DISC_VERSION OR _6502SP_VERSION

 EQUB 0

ELIF _MASTER_VERSION

 EQUB &FF

ENDIF

