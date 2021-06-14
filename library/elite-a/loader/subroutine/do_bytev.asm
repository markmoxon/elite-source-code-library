\ ******************************************************************************
\
\       Name: do_BYTEV
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

 \ trap BYTEV

.do_BYTEV

 CMP #&8F \ ROM service request
 BNE old_BYTEV
 CPX #&F \ vector claim?
 BNE old_BYTEV
 JSR old_BYTEV

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


.old_BYTEV

 JMP &100 \ address modified by master set_up

