\ ******************************************************************************
\
\       Name: set_vectors
\       Type: Subroutine
\   Category: Loader
\    Summary: Set the FILEV, FSCV and BYTEV vectors to point to our custom
\             handlers
\
\ ******************************************************************************

.set_vectors

 SEI                    \ Disable interrupts while we update the vectors

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA #LO(do_FILEV)      \ Set the FILEV to point to our custom handler in
 STA FILEV              \ do_FILEV
 LDA #HI(do_FILEV)
 STA FILEV+1

 LDA #LO(do_FSCV)       \ Set the FSCV to point to our custom handler in
 STA FSCV               \ do_FSCV
 LDA #HI(do_FSCV)
 STA FSCV+1

 LDA #LO(do_BYTEV)      \ Set the BYTEV to point to our custom handler in
 STA BYTEV              \ do_BYTEV
 LDA #HI(do_BYTEV)
 STA BYTEV+1

 PLA                    \ Restore A from the stack, so the subroutine doesn't
                        \ change its value

 CLI                    \ Enable interrupts again

 RTS                    \ Return from the subroutine

