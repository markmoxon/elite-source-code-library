\ ******************************************************************************
\
\       Name: acorn
\       Type: Variable
\   Category: Demo
\    Summary: The text for the demo's opening scroll text
\
\ ******************************************************************************

.acorn

IF _6502SP_VERSION \ 6502SP: The opening scroll text in the Executive version's demo says "PIZZASOFT PRESENTS" instead of "ACORNSOFT PRESENTS"

IF _SNG45 OR _SOURCE_DISC

 EQUS ":::ACORNSOFT::::"
 EQUS ";;;;;;;;;;;;;;;;"
 EQUS "::::PRESENTS"
 EQUB 0

ELIF _EXECUTIVE

 EQUS ":::PIZZASOFT::::"
 EQUS ";;;;;;;;;;;;;;;;"
 EQUS "::::PRESENTS"
 EQUB 0

ENDIF

ENDIF

