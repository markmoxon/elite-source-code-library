\ ******************************************************************************
\
\       Name: innersec
\       Type: Variable
\   Category: Drawing the screen
\    Summary: A table for converting the value of X from 0 to 1 or from 1 to 0,
\             for use when flipping RASCT between 0 and 1 on each interrupt
\
\ ******************************************************************************

.innersec

 EQUB 1                 \ Lookup value to change 0 to 1

 EQUB 0                 \ Lookup value to change 1 to 0

