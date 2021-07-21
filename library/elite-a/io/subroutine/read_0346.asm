\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Send the current value of LASCT to the parasite
\
\ ******************************************************************************

.read_0346

 LDA LASCT              \ Send the value of LASCT to the parasite and return
 JMP tube_put           \ from the subroutine using a tail call

