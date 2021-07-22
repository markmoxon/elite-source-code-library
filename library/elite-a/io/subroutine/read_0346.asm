\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Send the current value of LASCT to the parasite
\
\ ******************************************************************************

.read_0346

 LDA LASCT              \ Fetch the current value of LASCT into A

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

