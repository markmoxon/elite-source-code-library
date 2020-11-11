\ ******************************************************************************
\
\       Name: OSB
\       Type: Subroutine
\   Category: Utility routines
\    Summary: A convenience routine for calling OSBYTE with Y = 0
\
\ ******************************************************************************

.OSB

 LDY #0                 \ Call OSBYTE with Y = 0, returning from the subroutine
 JMP OSBYTE             \ using a tail call (so we can call OSB to call OSBYTE
                        \ for when we know we want Y set to 0)

