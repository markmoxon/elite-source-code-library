\ ******************************************************************************
\
\       Name: Firebird
\       Type: Variable
\   Category: Copy protection
\    Summary: The name "Firebird", buried in the code of the Executive version
\
\ ******************************************************************************

IF _6502SP_VERSION \ 6502SP: The Executive version contains an extra string, "Firebird", buried in the code, though it isn't used anywhere

IF _EXECUTIVE

 EQUS "Firebird"
 EQUB 13

ENDIF

ENDIF

