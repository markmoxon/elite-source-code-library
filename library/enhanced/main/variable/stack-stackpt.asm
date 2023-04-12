\ ******************************************************************************
\
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION \ Comment
\       Name: stack
ELIF _MASTER_VERSION
\       Name: stackpt
ENDIF
\       Type: Variable
\   Category: Save and load
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION \ Comment
\    Summary: Temporary storage for the stack pointer when switching the BRKV
\             handler between BRBR and MEBRK
ELIF _MASTER_VERSION
\    Summary: Temporary storage for the stack pointer when jumping to the break
\             handler at NEWBRK
ENDIF
\
\ ******************************************************************************

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION \ Label

.stack

 EQUB 0

ELIF _MASTER_VERSION

.stackpt

 EQUB &FF

ENDIF

