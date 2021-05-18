\ ******************************************************************************
\
\       Name: FLKB
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Flush the keyboard buffer
\
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ This routine does nothing in the BBC Master version of Elite. It does have a
\ function in the disc and 6502SP versions, so the authors presumably just
\ cleared out the FLKB routine for the Master version, rather than unplumbing it
\ from the code.
\
ENDIF
\ ******************************************************************************

.FLKB

IF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform: The cassette and Master versions don't explicitly flush the keyboard buffer, while the disc and 6502SP versions call OSBYTE 15 to flush the input buffers

 LDA #15                \ Call OSBYTE with A = 15 and Y <> 0 to flush the input
 TAX                    \ buffers (i.e. flush the operating system's keyboard
 JMP OSBYTE             \ buffer) and return from the subroutine using a tail
                        \ call

ELIF _MASTER_VERSION

 RTS                    \ Return from the subroutine

ENDIF

