\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Implement the read_0346 command (read LASCT)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a read_0346 command. It sends the
\ I/O processor's value of LASCT back to the parasite.
\
\ ******************************************************************************

.read_0346

 LDA LASCT              \ Fetch the current value of LASCT into A

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

