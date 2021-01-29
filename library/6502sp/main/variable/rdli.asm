\ ******************************************************************************
\
\       Name: RDLI
\       Type: Variable
\   Category: Utility routines
\    Summary: The OS command string for loading the docked code in the disc
\             version of Elite
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

