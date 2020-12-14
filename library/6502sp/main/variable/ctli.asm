\ ******************************************************************************
\
\       Name: CTLI
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for cataloguing a disc
\
\ ******************************************************************************

.CTLI

 EQUS ".0"              \ The "0" part of the string is overwritten with the
 EQUB 13                \ actual drive number by the CATS routine

