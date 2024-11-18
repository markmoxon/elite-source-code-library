\ ******************************************************************************
\
\       Name: F%
\       Type: Variable
\   Category: Utility routines
IF _6502SP_VERSION \ Comment
\    Summary: Denotes the end of the main game code, from ELITE A to ELITE J
ELIF _MASTER_VERSION
\    Summary: Denotes the end of the main game code, from ELITE A to ELITE H
ELIF _C64_VERSION OR _APPLE_VERSION
\    Summary: Denotes the end of the main game code, from ELITE A to ELITE K
ENDIF
\
\ ******************************************************************************

.F%

 SKIP 0

