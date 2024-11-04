\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: SETYC
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\       Name: DOYC
ENDIF
\       Type: Subroutine
\   Category: Text
IF _6502SP_VERSION \ Comment
\    Summary: Implement the #SETYC <row> command (move the text cursor to a
\             specific row)
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\    Summary: Move the text cursor to a specific row
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _6502SP_VERSION \ Comment
\ This routine is run when the parasite sends a #SETYC <row> command. It updates
\ the text cursor y-coordinate (i.e. the text row) in YC.
\
ENDIF
\ Arguments:
\
\   A                   The text row
\
\ ******************************************************************************

IF _6502SP_VERSION \ Label

.SETYC

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

.DOYC

ENDIF

 STA YC                 \ Store the new text row in YC

IF _6502SP_VERSION \ Tube

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTS                    \ Return from the subroutine

ENDIF

