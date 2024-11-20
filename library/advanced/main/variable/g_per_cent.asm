\ ******************************************************************************
\
\       Name: G%
\       Type: Variable
\   Category: Utility routines
IF _6502SP_VERSION \ Comment
\    Summary: Denotes the start of the main game code, from ELITE A to ELITE J
ELIF _MASTER_VERSION
\    Summary: Denotes the start of the main game code, from ELITE A to ELITE H
ELIF _C64_VERSION OR _APPLE_VERSION
\    Summary: Denotes the start of the main game code, from ELITE A to ELITE K
ENDIF
\
\ ******************************************************************************

.G%

 SKIP 0                 \ The game code is scrambled from here to F% (or, as the
                        \ original source code puts it, "mutilated")

