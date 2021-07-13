\ ******************************************************************************
\
\       Name: set_vectors
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

.set_vectors

 SEI
 PHA
 LDA #LO(do_FILEV) \ reset FILEV
 STA FILEV
 LDA #HI(do_FILEV)
 STA FILEV+1
 LDA #LO(do_FSCV) \ reset FSCV
 STA FSCV
 LDA #HI(do_FSCV)
 STA FSCV+1
 LDA #LO(do_BYTEV) \ replace BYTEV
 STA BYTEV
 LDA #HI(do_BYTEV)
 STA BYTEV+1
 PLA
 CLI
 RTS

