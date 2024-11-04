\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: SETVDU19
ELIF _C64_VERSION OR _MASTER_VERSION
\       Name: DOVDU19
ENDIF
\       Type: Subroutine
\   Category: Drawing the screen
IF _6502SP_VERSION \ Comment
\    Summary: Implement the #SETVDU19 <offset> command (change mode 1 palette)
ELIF _MASTER_VERSION
\    Summary: Change the mode 1 palette
ELIF _C64_VERSION
\    Summary: Change the trading screen palette
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _6502SP_VERSION \ Comment
\ This routine is run when the parasite sends a #SETVDU19 <offset> command.
\
ENDIF
IF _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ This routine updates the VNT3+1 location in the IRQ1 handler to change the
\ palette that's applied to the top part of the screen (the four-colour mode 1
\ part). The parameter is the offset within the TVT3 palette block of the
\ desired palette.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The offset within the TVT3 table of palettes:
\
\                         * 0 = Yellow, red, cyan palette (space view)
\
\                         * 16 = Yellow, red, white palette (charts)
\
\                         * 32 = Yellow, white, cyan palette (title screen)
\
\                         * 48 = Yellow, magenta, white palette (trading)
\
ENDIF
\ ******************************************************************************

IF _6502SP_VERSION \ Label

.SETVDU19

ELIF _C64_VERSION OR _MASTER_VERSION

.DOVDU19

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 STA VNT3+1             \ Store the new colour in VNT3+1, in the IRQ1 routine,
                        \ which modifies which TVT3 palette block gets applied
                        \ to the mode 1 part of the screen

ENDIF

IF _6502SP_VERSION \ Tube

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _C64_VERSION OR _MASTER_VERSION

 RTS                    \ Return from the subroutine

ENDIF

