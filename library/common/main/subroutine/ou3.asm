\ ******************************************************************************
\
\       Name: ou3
\       Type: Subroutine
\   Category: Text
\    Summary: Display "FUEL SCOOPS DESTROYED" as an in-flight message
\
\ ******************************************************************************

.ou3

 LDA #111               \ Set A to recursive token 111 ("FUEL SCOOPS")

IF _6502SP_VERSION

 JMP MESS               \ Print recursive token A as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ENDIF

