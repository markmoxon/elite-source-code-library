\ ******************************************************************************
\
\       Name: RDLI
\       Type: Variable
\   Category: Loader
IF NOT(_ELITE_A_VERSION)
\    Summary: The OS command string for running the flight code in file D.CODE
ELIF _ELITE_A_VERSION
\    Summary: The OS command string for running the flight code in file 1.F
ENDIF
IF _6502SP_VERSION OR _C64_VERSION \ Comment
\             in the disc version of Elite
ENDIF
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ This command is not used in the 6502 Second Processor version of Elite; it is
\ left over from the BBC Micro disc version.
\
ENDIF
IF _C64_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ This command is not used in the Commodore 64 version of Elite; it is left over
\ from the BBC Micro disc version.
\
ENDIF
\ ******************************************************************************

.RDLI

IF NOT(_ELITE_A_VERSION)

 EQUS "R.D.CODE"        \ This is short for "*RUN D.CODE"
 EQUB 13

ELIF _ELITE_A_VERSION

 EQUS "R.1.F"           \ This is short for "*RUN 1.F"
 EQUB 13

ENDIF

