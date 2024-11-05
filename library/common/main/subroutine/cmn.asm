\ ******************************************************************************
\
\       Name: cmn
\       Type: Subroutine
\   Category: Status
\    Summary: Print the commander's name
\
\ ------------------------------------------------------------------------------
\
\ Print control code 4 (the commander's name).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   cmn-1               Contains an RTS
\
\ ******************************************************************************

.cmn

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA \ Platform

 JSR MT19               \ Call MT19 to capitalise the next letter (i.e. set
                        \ Sentence Case for this word only)

ENDIF

 LDY #0                 \ Set up a counter in Y, starting from 0

.QUL4

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA \ Platform

 LDA NA%,Y              \ The commander's name is stored at NA%, so load the
                        \ Y-th character from NA%

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA NAME,Y             \ The commander's name is stored at NAME, so load the
                        \ Y-th character from NAME

ENDIF

IF NOT(_NES_VERSION)

 CMP #13                \ If we have reached the end of the name, return from
 BEQ ypl-1              \ the subroutine (ypl-1 points to the RTS below)

 JSR TT26               \ Print the character we just loaded

ELIF _NES_VERSION

 CMP #' '               \ If we have found a space, then we have reached the end
 BEQ ypl-1              \ of the name, return from the subroutine (ypl-1 points
                        \ to the RTS below)

 JSR DASC_b2            \ Print the character we just loaded

ENDIF

 INY                    \ Increment the loop counter

IF NOT(_NES_VERSION)

 BNE QUL4               \ Loop back for the next character

ELIF _NES_VERSION

 CPY #7                 \ Loop back for the next character until we have either
 BNE QUL4               \ found a carriage return or have printed seven
                        \ characters

ENDIF

 RTS                    \ Return from the subroutine

