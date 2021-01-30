\ ******************************************************************************
\
\       Name: RDLI
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for loading the flight code file D.CODE
IF _6502SP_VERSION
\             in the disc version of Elite
ENDIF
\
IF _6502SP_VERSION
\ ------------------------------------------------------------------------------
\
\ This command is not used in the 6502 Second Processor version of Elite.
\
ENDIF
\ ******************************************************************************

.RDLI

 EQUS "R.D.CODE"
 EQUB 13

