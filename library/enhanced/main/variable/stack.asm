\ ******************************************************************************
\
\       Name: stack
\       Type: Variable
\   Category: Save and load
\    Summary: Temporary storage for the stack pointer when switching the BRKV
\             handler between BRBR and MEBRK

\ ******************************************************************************

.stack

IF _DISC_DOCKED OR _6502SP_VERSION \ Platform

 EQUB 0

ELIF _MASTER_VERSION

 EQUB &FF

ENDIF

