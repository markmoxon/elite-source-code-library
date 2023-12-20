\ ******************************************************************************
\
\       Name: FR1
\       Type: Subroutine
\   Category: Tactics
\    Summary: Display the "missile jammed" message
\
\ ------------------------------------------------------------------------------
\
\ This is shown if there isn't room in the local bubble of universe for a new
\ missile.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   FR1-2               Clear the C flag and return from the subroutine
\
\ ******************************************************************************

.FR1

 LDA #201               \ Print recursive token 41 ("MISSILE JAMMED") as an
 JMP MESS               \ in-flight message and return from the subroutine using
                        \ a tail call

