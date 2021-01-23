\ ******************************************************************************
\
\       Name: cmn
\       Type: Subroutine
\   Category: Text
\    Summary: Print the commander's name
\
\ ------------------------------------------------------------------------------
\
\ Print control code 4 (the commander's name).
\
\ Other entry points:
\
\   ypl-1               Contains an RTS
\
\ ******************************************************************************

.cmn

IF _DISC_DOCKED

 JSR MT19               \ ????

ENDIF

 LDY #0                 \ Set up a counter in Y, starting from 0

.QUL4

IF _CASSETTE_VERSION

 LDA NA%,Y              \ The commander's name is stored at NA%, so load the
                        \ Y-th character from NA%

ELIF _DISC_DOCKED

 LDA NAME_DOCKED,Y      \ The commander's name is stored at NAME_DOCKED, so
                        \ load the Y-th character from NAME_DOCKED

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 LDA NAME,Y             \ The commander's name is stored at NAME, so load the
                        \ Y-th character from NAME

ENDIF

 CMP #13                \ If we have reached the end of the name, return from
 BEQ ypl-1              \ the subroutine (ypl-1 points to the RTS below)

 JSR TT26               \ Print the character we just loaded

 INY                    \ Increment the loop counter

 BNE QUL4               \ Loop back for the next character

 RTS                    \ Return from the subroutine

