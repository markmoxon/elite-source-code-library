\ ******************************************************************************
\
\       Name: RDLI
\       Type: Variable
\   Category: Loader
IF NOT(_ELITE_A_VERSION)
\    Summary: The OS command string for loading the flight code file D.CODE
ELIF _ELITE_A_VERSION
\    Summary: The OS command string for loading the flight code file 1.F
ENDIF
IF _6502SP_VERSION \ Comment
\             in the disc version of Elite
ENDIF
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ This command is not used in the 6502 Second Processor version of Elite.
\
ENDIF
\ ******************************************************************************

.RDLI

IF NOT(_ELITE_A_VERSION)

 EQUS "R.D.CODE"
 EQUB 13

ELIF _ELITE_A_VERSION

 EQUS "R.1.F"
 EQUB 13

ENDIF

