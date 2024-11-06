\ ******************************************************************************
\
\       Name: backtonormal
\       Type: Subroutine
\   Category: Utility routines
IF _6502SP_VERSION \ Comment
\    Summary: Disable the keyboard, set the SVN flag to 0, and return with A = 0
ELIF _MASTER_VERSION OR _APPLE_VERSION
\    Summary: Do nothing
ENDIF
\
\ ******************************************************************************

.backtonormal

IF _6502SP_VERSION \ Platform

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

 LDA #0                 \ Set the SVN flag to 0 and return from the subroutine
 BEQ DODOSVN            \ using a tail call (this BEQ is effectively a JMP as A
                        \ is always zero)

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTS                    \ Return from the subroutine, as backtonormal does
                        \ nothing in this version of Elite (it is left over from
                        \ the 6502 Second Processor version)

ENDIF

