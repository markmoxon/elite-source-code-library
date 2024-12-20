\ ******************************************************************************
\
IF _DISC_DOCKED OR _6502SP_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
\       Name: BRKBK
ELIF _MASTER_VERSION
\       Name: COLD
ENDIF
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
ELIF _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
ENDIF
\ ******************************************************************************

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Platform

.BRKBK

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine
 STA BRKV
 LDA #HI(BRBR)
 STA BRKV+1

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

.BRKBK

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine, disabling
 SEI                    \ interrupts while we make the change and re-enabling
 STA BRKV               \ them once we are done
 LDA #HI(BRBR)
 STA BRKV+1
 CLI

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

.COLD

 LDA #LO(NEWBRK)        \ Set BRKV to point to the NEWBRK routine
 STA BRKV
 LDA #HI(NEWBRK)
 STA BRKV+1

 LDA #LO(CHPR)          \ Set WRCHV to point to the CHPR routine
 STA WRCHV
 LDA #HI(CHPR)
 STA WRCHV+1

 JSR setzp              \ Call setzp to copy the top part of zero page into
                        \ the buffer at &3000

 JSR SETINTS            \ Call SETINTS to set various vectors, interrupts and
                        \ timers

 JMP SOFLUSH            \ Call SOFLUSH to reset the sound buffers and return
                        \ from the subroutine using a tail call

ENDIF

