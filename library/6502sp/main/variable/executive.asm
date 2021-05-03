\ ******************************************************************************
\
\       Name: executive
\       Type: Variable
\   Category: Demo
\    Summary: Extra text for the demo in the Executive version
\
\ ******************************************************************************

.executive

IF _6502SP_VERSION \ 6502SP: The Executive version's demo includes an extra bit of text: "THE EXECUTIVE VERSION"

IF _EXECUTIVE

 EQUS "::::::THE;::::::"
 EQUS ";;;EXECUTIVE;;;;"
 EQUS "::::VERSION"
 EQUB 0

ENDIF

ENDIF

