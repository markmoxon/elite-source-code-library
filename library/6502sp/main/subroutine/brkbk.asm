\ ******************************************************************************
\
\       Name: BRKBK
\       Type: Subroutine
\   Category: Save and load
\    Summary: Set the standard BRKV handler for the game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to this routine by the BRKBK routine, which is called by the
\ decryption routine at DEEOR just before the game is run for the first time,
\ and at the end of the SVE routine after the disc access menu has been
\ processed (so this resets BRKV to the standard BRKV handler for the game).
\
\ ******************************************************************************

.BRKBK

 LDA #LO(BRBR)          \ Set BRKV to point to the BRBR routine, disabling
 SEI                    \ while we make the change and re-enabling them once we
 STA BRKV               \ are done
 LDA #HI(BRBR)
 STA BRKV+1
 CLI

 RTS                    \ Return from the subroutine

