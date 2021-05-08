
\ ******************************************************************************
\
\       Name: DIRI
\       Type: Subroutine
\   Category: Save and load
\    Summary: The OS command string for changing directory on the Master Compact
\
\ ******************************************************************************

IF _COMPACT

.DIRI

 EQUS "DIR 12345678901234567890"
 EQUB 13

ENDIF

