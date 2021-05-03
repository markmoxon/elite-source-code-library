\ ******************************************************************************
\
\       Name: true3
\       Type: Variable
\   Category: Demo
\    Summary: The text for the demo's final scroll text
\
\ ******************************************************************************

.true3

IF _6502SP_VERSION \ 6502SP: The Executive version's demo contains the scroll text "CONGRATULATIONS ON OBTAINING A COPY OF THIS ELUSIVE PRODUCT.", which is shown in place of the "GALAXY IS IN TURMOIL" text

IF _SNG45 OR _SOURCE_DISC

 EQUS "THE:GALAXY:IS:IN"
 EQUS "TURMOIL,THE:NAVY"
 EQUS "FAR:AWAY:AS::THE"
 EQUS "EMPIRE:CRUMBLES."
 EQUB 0

ELIF _EXECUTIVE

 EQUS "CONGRATULATIONS:"
 EQUS ";ON;OBTAINING;A;"
 EQUS "::COPY:OF:THIS::"
 EQUS "ELUSIVE;PRODUCT."
 EQUB 0

ENDIF

ENDIF

