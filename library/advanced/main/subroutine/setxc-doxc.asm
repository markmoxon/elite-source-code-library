\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: SETXC
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\       Name: DOXC
ENDIF
\       Type: Subroutine
\   Category: Text
IF _6502SP_VERSION \ Comment
\    Summary: Implement the #SETXC <column> command (move the text cursor to a
\             specific column)
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\    Summary: Move the text cursor to a specific column
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _6502SP_VERSION \ Comment
\ This routine is run when the parasite sends a #SETXC <column> command. It
\ updates the text cursor x-coordinate (i.e. the text column) in XC.
\
ENDIF
\ Arguments:
\
\   A                   The text column
\
\ ******************************************************************************

IF _6502SP_VERSION \ Label

.SETXC

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

.DOXC

ENDIF

 STA XC                 \ Store the new text column in XC

IF _6502SP_VERSION \ Tube

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTS                    \ Return from the subroutine

ENDIF

