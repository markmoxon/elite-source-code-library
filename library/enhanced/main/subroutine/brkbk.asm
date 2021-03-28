\ ******************************************************************************
\
\       Name: BRKBK
\       Type: Subroutine
\   Category: Save and load
\    Summary: Set the standard BRKV handler for the game
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ BRKV is set to this routine by the BRKBK routine, which is called by the
\ decryption routine at DEEOR just before the game is run for the first time,
\ and at the end of the SVE routine after the disc access menu has been
\ processed (so this resets BRKV to the standard BRKV handler for the game).
\
ENDIF
\ ******************************************************************************

.BRKBK

IF _DISC_DOCKED \ Platform

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine
 STA BRKV
 LDA #HI(BRBR)
 STA BRKV+1

ELIF _6502SP_VERSION

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine, disabling
 SEI                    \ interrupts while we make the change and re-enabling
 STA BRKV               \ them once we are done
 LDA #HI(BRBR)
 STA BRKV+1
 CLI

ELIF _MASTER_VERSION

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine
 STA BRKV
 LDA #HI(BRBR)
 STA BRKV+1

 LDA #LO(CHPR)          \ Set WRCHV to point to the CHPR routine
 STA WRCHV
 LDA #HI(CHPR)
 STA WRCHV+1

 JSR SAVEZP             \ Call SAVEZP to backup the top part of zero page

 JSR STARTUP            \ Call STARTUP to set various vectors, interrupts and
                        \ timers

 JMP SRESET             \ Call SRESET to reset the sound buffers

 CLI                    \ Enable interrupts

ENDIF

IF _DISC_DOCKED OR _6502SP_VERSION \ Platform

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 RTI                    \ Return from the interrupt handler

ENDIF

